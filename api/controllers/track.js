// function: multipleTracks
// if no specified album id, sends all tracks in the database
// if specified album id, returns all tracks in the given album
export async function multipleTracks(req, res) {
  let conn;
  let q;
  const albumid = parseInt(req.query.albumid, 10);
  let result;
  try {
    conn = await req.app.locals.pool.getConnection();
    if (albumid) {
      q =
        'SELECT * FROM `TrackAlbum` LEFT JOIN `Track`' +
        'ON `TrackAlbum`.`Album` = `Track`.`ID` WHERE `Album` = ?';
      result = await conn.query(q, [albumid]);
    } else {
      q = 'SELECT * FROM `Track`;';
      result = await conn.query(q);
    }
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

// function: byTrackID
// sends the track with the given id
export async function byTrackID(req, res) {
  let conn;
  const trackID = parseInt(req.params.trackID, 10);
  try {
    conn = await req.app.locals.pool.getConnection();
    const q = 'SELECT * FROM `Track` WHERE `Track`.`ID` = ?;';
    const result = await conn.query(q, [trackID]);
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
