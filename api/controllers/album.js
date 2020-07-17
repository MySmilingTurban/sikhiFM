// function: allAlbums
// sends all parent albums
export async function allAlbums(req, res) {
  let conn;
  try {
    conn = await req.app.locals.pool.getConnection();
    const q = 'SELECT * FROM Album WHERE Parent IS NULL;';
    const result = await conn.query(q);
    res.json(result);
    return;
  } catch (err) {
    res.json(`error${err}`);
    return;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}

// // function:byAlbumID
// // sends the album with the given id
export async function byAlbumID(req, res) {
  let conn;
  const albumID = parseInt(req.params.albumID, 10);
  try {
    conn = await req.app.locals.pool.getConnection();
    const q = 'SELECT * FROM `Album` WHERE `ID` = ?;';
    const result = await conn.query(q, albumID);
    res.json(result);
    return;
  } catch (err) {
    res.json(`error${err}`);
    return;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}
