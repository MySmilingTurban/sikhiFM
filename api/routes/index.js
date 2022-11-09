const os = require('os');
const express = require('express');
const pjson = require('../../package.json');
const {getTracks, getAllTracks} = require('../controllers/tracks');
const pool = require('../config');
const healthcheck = require('../controllers/healthcheck');
const route = express.Router();

// Routes
const db_name = process.env.NODE_ENV === 'production' ? process.env.DB_NAME : 'apidb';

route.get('/', (req, res) => {
    res.json({
        name: 'SikhiToTheMax Audio API',
        version: pjson.version,
        endpoint: os.hostname(),
    });
});

route.get('/health', async (req, res) => {
    const sqlQuery = `SELECT 1 as \`ok\` FROM \`${db_name}\`.\`tracks\` WHERE \`track_id\`=1 LIMIT 1`;
    healthcheck(req, res, sqlQuery);
});

route.get('/tracks', async(req, res) => {
    const sqlQuery = "SELECT * FROM `" + db_name + "`.`tracks`;";
    getAllTracks(req, res, sqlQuery, 'tracksall');
});

route.get('/tracks/:track_id', async function(req,res){
    const sqlQuery = "SELECT * FROM `" + db_name + "`.`tracks` WHERE `track_id`="+`${req.params.track_id}`+";";
    getTracks(req, res, sqlQuery, 'tracks');
});

route.get('/shabads/:shabad_id', async function(req,res){
    const sqlQuery = "SELECT * FROM `" + db_name + "`.`tracks` WHERE `shabad_id`="+`${req.params.shabad_id}`+";";
    getTracks(req, res, sqlQuery, 'shabads');
});

exports.routes = route;
