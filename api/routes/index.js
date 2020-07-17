// dependencies
import * as os from 'os';
import express from 'express';
import * as pjson from '../../package.json';
import limiter from '../controllers/limiter';
import { healthcheck } from '../controllers/healthcheck';
import { allAlbums, byAlbumID } from '../controllers/album';
import { multipleTracks, byTrackID } from '../controllers/track';

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

// all albums
route.get('/albums', limiter.rate250, allAlbums);

// by album id
route.get('/albums/:albumID', limiter.rate250, byAlbumID);

// all tracks
route.get('/tracks', limiter.rate250, multipleTracks);

// by track id
// all tracks in an album via:
// tracks?albumid={albumid}'
route.get('/tracks/:trackID', limiter.rate250, byTrackID);

// exports the entire route object
export default route;
