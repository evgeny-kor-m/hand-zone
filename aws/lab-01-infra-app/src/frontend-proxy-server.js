//-----------------------------------------------------------------------------------------------//
// 1. The browser sends a request → app.use('/api', ...) catches it
// 2. STEP 1 — collect options (where to call), nothing has been sent yet
// 3. STEP 2 — http.request(options, callback) creates a request to the backend,
//             the callback is NOT executed YET — it's simply "postponed" for later
// 4. STEP 3 — req.pipe(proxyReq) — send the request body (if any) to the backend
// 5. STEP 4 — wait for the backend response (this happens asynchronously, without explicit code)
// 6. STEP 5 — the backend has responded → NOW the callback from step 3 is triggered,
// forward the response back to the browser
//-----------------------------------------------------------------------------------------------//

const express = require('express');
const path = require('path');
const http = require('http');

const app = express();
const PORT = process.env.PORT || 8080;

// Backend is only reachable from inside the VPC (private IP) — proxy from here
const BACKEND_HOST = process.env.BACKEND_HOST || '10.0.2.138';
const BACKEND_PORT = process.env.BACKEND_PORT || 3000;

// Serve the static frontend (index.html, css, js)
app.use(express.static(path.join(__dirname, 'public')));

// Catch any request starting with /api (e.g. /api/counter, /api/messages)
app.use('/api', (req, res) => {

  // STEP 1 — describe where to send the request (backend), not sent yet
  const options = {
    hostname: BACKEND_HOST,                 // '10.0.2.138'
    port: BACKEND_PORT,                     // 3000
    path: req.originalUrl,                  // same path browser asked for, e.g. '/api/messages'
    method: req.method,                     // same method: GET / POST
    headers: { ...req.headers, host: `${BACKEND_HOST}:${BACKEND_PORT}` }
  };

  // STEP 2 — create a NEW request to the backend using the options above.
  // The callback below only runs LATER, once the backend responds.
  const proxyReq = http.request(options, (proxyRes) => {
    // STEP 5 — backend responded (proxyRes) → forward its status/headers/body to the browser
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res, { end: true });
  });

  // STEP X (anytime) — if backend is unreachable, don't hang, respond with an error
  proxyReq.on('error', (err) => {
    console.error('Proxy error:', err.message);
    res.status(502).json({ error: 'Backend unreachable', details: err.message });
  });

  // STEP 3 — forward the browser's request body (if any, e.g. JSON on POST) into the backend request
  req.pipe(proxyReq, { end: true });

  // STEP 4 — (happens automatically) wait for the backend to respond → triggers STEP 5 above
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Frontend + proxy running on http://0.0.0.0:${PORT}`);
  console.log(`Proxying /api -> http://${BACKEND_HOST}:${BACKEND_PORT}`);
});