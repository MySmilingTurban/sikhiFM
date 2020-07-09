// function: multipleTracks
// if no specified album id, sends all tracks in the database
// if specified album id, returns all tracks in the given album
const multipleTracks = async (req, res) => {
  let conn;
  let q;
  const albumid = req.query.albumid;
  try {
    conn = await req.app.locals.pool.getConnection();
    if(albumid) {
      q = 'SELECT * FROM `sikhifm_db`.`TrackAlbum` LEFT JOIN `sikhifm_db`.`Track`'+
       'ON `TrackAlbum`.`Album` = `Track`.`ID` WHERE `TrackAlbum`.`Album` =' + albumid + ';';
    }
    else{
      q = 'SELECT * FROM `sikhifm_db`.`Track`;';
    }
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
};

exports.multipleTracks = multipleTracks;

// function: tracksInAlbumID
// sends all tracks in a given album by id
const tracksInAlbumID = async (req, res) => {
  console.log('tracks in album');
  res.send("ok");
  //res.send(req.params.albumid);
};

exports.tracksInAlbumID = tracksInAlbumID;

// function: byTrackID
// sends the track with the given id
const byTrackID = async (req, res) => {
  let conn;
  const trackID = parseInt(req.params.trackID, 10);
  console.log(`track id: ${trackID}`);

  try {
    conn = await req.app.locals.pool.getConnection();
    const q = `SELECT * FROM \`sikhifm_db\`.\`Track\` WHERE \`Track\`.\`ID\` = ${trackID};`;
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
};

exports.byTrackID = byTrackID;
