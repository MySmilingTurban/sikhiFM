// imports
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const cacheControl = require('express-cache-controller');
const { createPool } = require('mariadb');
const config = require('./api/config');
const routes = require('./api/routes');

// app initialization with express on port 3004 (3005 for development)
const app = express();
const port = process.env.NODE_ENV === 'development' ? '3005' : '3004';

// creates the pool according to the config
app.locals.pool = createPool(config);

// adds middleware to the app
app.use(cors());
app.use(cacheControl({ maxAge: 21600 }));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/v1', routes);

// sends error 404 message if necessary
app.use((req, res) => {
  res.cacheControl = { noCache: true };
  res.status(404).send({ url: `${req.originalUrl} not found` });
});

// connection to port
app.listen(port, () => {
  console.log(`SikhiFM API start on port ${port}`);
});

module.exports = app;
