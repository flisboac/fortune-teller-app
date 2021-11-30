const util = require('util');
const { exec: rawExec } = require('child_process');
const exec = util.promisify(rawExec);

const express = require('express');
const cors = require('cors');

const APP_PORT = Number(process.env.APP_PORT || 3000);

const app = express();

app
  .use(cors())
  .options('*')
  .get('/fortune', async (req, res) => {
    try {
      const { stdout } = await exec('/usr/games/fortune', { env: process.env });
      const data = String(stdout);
      res.json({ data });
    } catch (error) {
      const errors = [
        {
          name: typeof error === 'object' && error ? String(error.name || error.constructor.name) : String(error),
          message: typeof error === 'object' && error ? String(error.message) : String(error),
          stack: typeof error === 'object' && error ? error.stack : undefined,
        }
      ]
      res.status(500).json({ errors });
    }
  });

const server = app.listen(APP_PORT, () => {
  console.log(`Aplicação sendo executada na porta ${server.address().port}`);
});
