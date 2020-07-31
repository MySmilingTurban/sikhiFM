// dependencies
import * as os from 'os';
import express from 'express';
import * as pjson from '../../package.json';
import limiter from '../controllers/limiter';
import { healthcheck } from '../controllers/healthcheck';
import { byAlbumID, albumsBy } from '../controllers/album';
import { byTrackID, tracksBy } from '../controllers/track';

const route = express.Router();

// Routes

// landing
route.get('/', limiter.rate250, (req, res) => {
  res.json({
    name: 'SikhiFM API',
    version: pjson.js,
    documentation: 'route for SikhiFM api',
    endpoint: os.hostname().substr(0, 3),
  });
});

// hello world
route.get('/hello', limiter.rate250, (req, res) => res.send('Hello World!'));

// healthcheck
route.get('/health', limiter.rate250, healthcheck);

// ALBUMS
/**
 * /albums : all albums
 * /albums?name={name} : Search for album that matches this name (fuzzy match)
 * /albums?tag={tag} : Search for albums that have these tags (fuzzy matches)
 * /albums?keyword={keyword} : Search for albums that have these keywords (fuzzy matches)
 * /albums?parentID={parentID} : Search for albums that has this albumId as a parent.
 * /albums?updated={updated} : Search for albums that were last updated after this date.
 * /albums?artistID={artistID} : Search for all albums that have this artist (exact match)
 */
route.get('/albums', limiter.rate250, albumsBy);

// by album id
route.get('/albums/:albumID', limiter.rate250, byAlbumID);

// TRACKS
/**
 * /tracks : all tracks
 * /tracks?albumID={albumID} : Search for tracks that have this albumID
 * /tracks?name={name} : Search for tracks that matches this name (fuzzy match)
 * /tracks?length={length} : Search for tracks are longer than X seconds.
 * /tracks?type={type} : Search for tracks that match this type (exact match)
 * /tracks?artistID={artistID} : Search for tracks that have this artistId
 * /tracks?artistName={artistName} : Search for tracks by artist name (fuzzy match)
 * /tracks?location={location} : Search for tracks by country name/city name/state name (fuzzy match)
 */
route.get('/tracks', limiter.rate250, tracksBy);

// by track id
route.get('/tracks/:trackID', limiter.rate250, byTrackID);

// exports the entire route object
export default route;
