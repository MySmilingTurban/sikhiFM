import { addSpecs, splitString } from './utils';

/**
 * function: tracksBy
 * sends all albums according to the given to the search query
 * if none are specified, all parent albums are returned
 *
 * @param {Request} req - Express request object
 * @param {Response} res - Express response object
 *
 * /tracks : all tracks
 * /tracks?albumID={albumID} : Search for tracks that have this albumID
 * /tracks?name={name} : Search for tracks that matches this name (fuzzy match)
 * /tracks?length={length} : Search for tracks are longer than X seconds.
 * /tracks?type={type} : Search for tracks that match this type (exact match)
 * /tracks?artistID={artistID} : Search for tracks that have this artistId
 * /tracks?artistName={artistName} : Search for tracks by artist name (fuzzy match)
 * /tracks?location={location} : Search for tracks by country name/city name/state name (fuzzy match)
 */
export async function tracksBy(req, res) {
  let conn;
  const albumID = parseInt(req.query.albumID, 10);
  const artistID = parseInt(req.query.artistid, 10);
  const { names, length, type, artistName, location } = req.query;
  const { query, params } = getTrackQuery({
    albumID,
    artistID,
    names,
    length,
    type,
    artistName,
    location,
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
 *
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
 * @param {Int} names - parentID for exact search
 * @param {String} length - updated after given date
 * @param {String} type - keyword for fuzzy search
 * @param {Int} trackID - albumID for exact search
 * @param {String} artistName - artist name for fuzzy search
 * @param {String} location - location (country, city, or state) for fuzzy search
 *
 * @return {Object[String, Array]} = template statement, parameters for template statement
 */

function getTrackQuery({ albumID, artistID, names, length, type, trackID, artistName, location }) {
  let cols =
    'Track.ID, Track.Title, Track.Media, TrackAlbum.Track, TrackAlbum.Album, Track.Length, Track.Updated';
  let joins = 'LEFT JOIN TrackAlbum ON TrackAlbum.Album = Track.ID';
  let specifications = ' WHERE 1 = 1';
  let params = [];
  // artist's name
  if (artistName) {
    cols +=
      ', Artist.ID as ArtistID, Artist.Name, Artist.NameGurmukhi,' +
      ' Artist.Description, Artist.Detail, Artist.Tags as ArtistTags, ' +
      ' Artist.Keywords as ArtistKeywords ';
    joins += ' LEFT JOIN Artist ON Track.Artist = Artist.ID';
    specifications += ' AND lower(Artist.Name) Like lower(?)';
    params.push(`%${artistName}%`);
  }
  // location
  if (location) {
    cols +=
      ', Location.City, Location.State, Location.Country, Location.Nickname as LocationNickname';
    joins += ' LEFT JOIN Location ON Track.Location = Location.ID';
    specifications =
      ' AND lower(City) Like lower(?) OR lower(State) LIKE lower(?) OR lower(Country) LIKE lower(?)';
    params.push(`%${location}%`);
    params.push(`%${location}%`);
    params.push(`%${location}%`);
  }
  // album id
  if (albumID) {
    specifications += ' AND Album = ?';
    params.push(albumID.toString());
  }
  // artist id
  if (artistID) {
    specifications += ' AND Artist = ?';
    params.push(artistID.toString());
  }
  // name
  if (names) {
    const namesArr = splitString(names);
    specifications += addSpecs(' AND lower(Title) LIKE lower(?)', namesArr.length);
    params = params.concat(namesArr);
  }
  // length
  if (length) {
    specifications += ' AND lower(Length) > lower(?)';
    params.push(`${length}`);
  }
  // type
  if (type) {
    specifications += ' AND Type = ?';
    params.push(`${type}`);
  }
  // track id
  if (trackID) {
    specifications += ' AND ID = ?';
    params.push(trackID.toString());
  }
  return { query: `SELECT  ${cols} FROM Track ${joins + specifications} GROUP BY ID;`, params };
}
