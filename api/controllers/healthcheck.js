// function: healthcheck
// simple request to see if the service is up and running
// selects something from a generic table which is garunteed to be true if the database is connected
exports.healthcheck = async (req, res) => {
  let conn;
  try {
    conn = await req.app.locals.pool.getConnection();
    const q = 'SELECT 1 as ok FROM Track WHERE ID=1 LIMIT 1';
    const result = await conn.query(q);
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
