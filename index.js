require('dotenv').config();
const express = require("express");
const bodyParser = require('body-parser');
const cors = require('cors');
const cacheControl = require('express-cache-controller');
const {routes} = require('./api/routes');
const config = require('./api/config');
const mariadb = require("mariadb");
const app = express();

// creates the pool according to the config
app.locals.pool = mariadb.createPool({
        host: 'localhost',
        user: 'chardikala',
        password: '',
        database: 'apidb',
        port: '3306',
        connectionLimit: 5,
        multipleStatements: true,
    });

app.use(express.json());
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
const port = process.env.PORT || 3000;

app.listen(
    port,
    () => console.log(`Server listening on http://localhost:${port}`)
)