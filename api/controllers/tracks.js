const pool = require('../config');

const getTracks = async(req, res, sqlQuery, type) => {
    let conn;
    try {
        conn = await req.app.locals.pool.getConnection();
        rows = await conn.execute(sqlQuery);
        data = rows[0];
        if (typeof(data) !== 'undefined') {
            data['track_url'] = `http://94.130.59.126/${data['track_url']}`;
            const json = {
                "status":"success",
                ...data
            };
            res.status(200).json(json);
        } else {
            res.status(404).send('Track not found');
        }
    } catch (error) {
        res.status(400).send(error.message)
    }
};

const getAllTracks = async(req, res, sqlQuery, type) => {
    let conn;
    try {
        conn = await req.app.locals.pool.getConnection();
        rows = await conn.execute(sqlQuery);
        data = [];
        rows.forEach(row => {
            row['track_url'] = `http://94.130.59.126/${row['track_url']}`;
            data.push(row);
        });
        if (typeof(rows[0]) !== 'undefined') {
            const json = {
                "status":"success",
                "number_of_tracks":data.length,
                "tracks": data
            };
            res.status(200).json(json);
        } else {
            res.status(404).send('Track not found');
        }
    } catch (error) {
        res.status(400).send(error.message)
    }
};

module.exports = {getTracks, getAllTracks};