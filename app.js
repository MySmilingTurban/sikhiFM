// dependencies
import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import cacheControl from 'express-cache-controller';
import mariadb from 'mariadb';
import { config } from './api/config';
import routes from './api/routes';

// app initialization with express on port 3004 (3005 for development)
const app = express();
const port = process.env.NODE_ENV === 'development' ? '3005' : '3004';

// creates the pool according to the config
app.locals.pool = mariadb.createPool(config);

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
// app.listen(port, () => {
//   console.log(`SikhiFM API start on port ${port}`);
// });

app.listen(port, () => {
  console.log(`SikhiFM API start on port ${port}`);
});
