const express = require('express');
const os = require('os');

const app = express();
const port = 8080;

function getPrivateIp() {
  const interfaces = os.networkInterfaces();

  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }

  return 'Unknown';
}

app.get('/', (req, res) => {
  res.send(`Hello World!<br>Instance IP: ${getPrivateIp()}`);
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});