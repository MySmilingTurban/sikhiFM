// function: allAlbums
// sends all parent albums

/**
 * /albums : all albums
 * /albums?name={name} : Search for album that matches this name (fuzzy match)
 * /albums?tag={tag} : Search for albums that have these tags (fuzzy matches)
 * /albums?keyword={keyword} : Search for albums that have these keywords (fuzzy matches)
 * /albums?parentID={parentID} : Search for albums that has this albumId as a parent.
 * /albums?updated={updated} : Search for albums that were last updated after this date.
 */
export async function albumsBy(req, res) {
  let conn;
  const parentID = parseInt(req.query.parentID, 10);
  const { name, tag, keyword, updated } = req.query;
  const { query, params } = getAlbumQuery({
    name,
    tag,
    parentID,
    updated,
    keyword,
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

// function:byAlbumID
// sends the album with the given id
export async function byAlbumID(req, res) {
  let conn;
  const albumID = parseInt(req.params.albumID, 10);
  const { query, params } = getAlbumQuery({ albumID });
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
 *
 * @param {String} name - string for fuzzy search
 * @param {String} tag - tag for fuzzy search
 * @param {Int} parentID - parentID for exact search
 * @param {String} date - updated after given date
 * @param {String} keyword - keyword for fuzzy search
 * @param {Int} albumID - albumID for exact search
 *
 * @return {Object[String, Array]} = template statement, parameters for template statement
 */
function getAlbumQuery({ name, tag, parentID, updated, keyword, albumID }) {
  const cols ='ID, Title, Parent, Tags, Keywords, Artists, Updated';
  const params = [];
  let q = '';
  const basicQuery = `SELECT ${cols} FROM Album WHERE 1=1`;
  // parent
  if (parentID) {
    q += ' AND Album.Parent = ?';
    params.push(parentID.toString());
  }
  // name
  if (name) {
    q += ' AND Album.Title LIKE ?';
    params.push(`%${name}%`);
  }
  // tag
  if (tag) {
    q += ' AND Album.Tags LIKE ?';
    params.push(`%${tag}%`);
  }
  // date
  if (updated) {
    q += ' AND Album.Updated > ?';
    params.push(`${updated}`);
  }
  // keyword
  if (keyword) {
    q += ' AND Album.Keywords LIKE ?';
    params.push(`%${keyword}%`);
  }
  // album id
  if (albumID) {
    q += ' AND Album.ID = ?';
    params.push(albumID.toString());
  }
  return { query: `${basicQuery} ${q};`, params };
}
