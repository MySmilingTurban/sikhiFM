/**
 * /tracks : all tracks
 * /tracks?albumID={albumID} : Search for tracks that have this albumID
 * /tracks?name={name} : Search for tracks that matches this name (fuzzy match)
 * /tracks?length={length} : Search for tracks are longer than X seconds.
 * /tracks?type={type} : Search for tracks that match this type (exact match)
 * /tracks?artistID={artistID} : Search for tracks that have this artistId
 */
export async function tracksBy(req, res) {
  let conn;
  const albumID = parseInt(req.query.albumID, 10);
  const artistID = parseInt(req.query.artistid, 10);
  const { name, length, type } = req.query;
  const { query, params } = getTrackQuery({
    albumID,
    artistID,
    name,
    length,
    type,
  });

  try {
    conn = await req.app.locals.pool.getConnection();
    const result = await conn.query(query, params);
    res.json(result);
  } catch (err) {
    res.json(`error${err}`);
    return;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}

/**
 * function: byTrackID
 * sends the track with the given id
 * @param {Request} req
 * @param {Response} res
 */
export async function byTrackID(req, res) {
  let conn;
  const trackID = parseInt(req.params.trackID, 10);
  const { query, params } = getTrackQuery({ trackID });
  try {
    conn = await req.app.locals.pool.getConnection();
    const result = await conn.query(query, params);
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

/**
 * function: getAlbumQuery
 * creates query and parameters for an album query to the database
 * currently does not work with prepared statements
 *
 * @param {String} albumID - string for fuzzy search
 * @param {String} artistID - tag for fuzzy search
 * @param {Int} name - parentID for exact search
 * @param {String} length - updated after given date
 * @param {String} type - keyword for fuzzy search
 * @param {Int} trackID - albumID for exact search
 *
 * @return {Object[String, Array]} = template statement, parameters for template statement
 */

function getTrackQuery({
  albumID,
  artistID,
  name,
  length,
  type,
  trackID,
}) {
  const cols = `ID, Title, Media, Length, Updated`;
  const params = [];
  let q = '';
  const basicQuery = `SELECT ${cols} FROM Track LEFT JOIN TrackAlbum ON TrackAlbum.Album = Track.ID WHERE 1=1`;
  // album id
  if (albumID) {
    q += ' AND Album = ?';
    params.push(albumID.toString());
  }
  // artist id
  if (artistID) {
    q += ' AND Artist = ?';
    params.push(artistID.toString());
  }
  // name
  if (name) {
    q += ' AND Title LIKE ?';
    params.push(`%${name}%`);
  }
  // length
  if (length) {
    q += ' AND Length > ?';
    params.push(`${length}`);
  }
  // type
  if (type) {
    q += ` AND Type = ?`;
    params.push(`${type}`);
  }
  // track id
  if (trackID) {
    q += ' AND ID = ?';
    params.push(trackID.toString());
  }
  return { query: `${basicQuery + q};`, params };
}
