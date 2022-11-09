
const healthcheck = async (req, res, q) => {
    let conn;
    try {
        conn = await req.app.locals.pool.getConnection();
        const result = await conn.execute(q);
        result[0].ok = result[0].ok === 1;
        res.send(result[0]);
        return;
    } catch (err) {
        res.json(`error${err}`);
        return;
    } finally {
        if (conn) {
        conn.end();
        }
    }
};

module.exports = healthcheck;