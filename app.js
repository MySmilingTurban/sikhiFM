// starts the express server
// import other stuff from the folders

const express = require('express');

const bodyParser = require('body-parser');
const cors = require('cors');
const cacheControl = require('express-cache-controller');
const { createPool } = require('mariadb');
const config = require('./api/config');
const routes = require('./api/routes');




const app = express();
const port = process.env.NODE_ENV === 'development' ? '3005' : '3004';




// app
app.use(cors());
app.use(cacheControl({ maxAge: 21600 }));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/v1', routes);

// error 404
app.use((req, res) => {
    res.cacheControl = { noCache: true };
    res.status(404).send({ url: `${req.originalUrl} not found` });
  });
  

  // connection to port
  app.listen(port, () => {
    console.log(`SikhiFM API start on port ${port}`);
  });


  module.exports = app;