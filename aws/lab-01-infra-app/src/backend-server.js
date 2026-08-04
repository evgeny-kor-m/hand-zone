const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors()); // allow requests from frontend EC2 (different origin)
app.use(express.json());

let counter = 0;
const messages = [];

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

app.get('/api/counter', (req, res) => {
  res.json({ counter });
});

app.post('/api/counter/increment', (req, res) => {
  counter++;
  res.json({ counter });
});

app.get('/api/messages', (req, res) => {
  res.json(messages);
});

app.post('/api/messages', (req, res) => {
  const { text } = req.body;
  if (!text) {
    return res.status(400).json({ error: 'text is required' });
  }
  const message = { id: messages.length + 1, text, time: new Date().toISOString() };
  messages.push(message);
  res.status(201).json(message);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend API running on http://0.0.0.0:${PORT}`);
});