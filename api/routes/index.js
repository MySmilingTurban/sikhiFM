// imports
const os = require('os');
const { Router } = require('express');

// file connections
const pjson = require('../../package.json');
const limiter = require('../controllers/limiter');
const healthcheck = require('../controllers/healthcheck');
const album = require('../controllers/album');
const track = require('../controllers/track');

const route = Router();

// ASK WHAT THIS DOES EXACTLY
route.get('/', limiter.rate100, (req, res) => {
  res.json({
    name: 'SikhiFM API',
    version: pjson.js,
    documentation: 'route for SikhiFM api',
    endpoint: os.hostname().substr(0, 3),
  });
});

// Routes

// hello world
route.get('/hello', (req, res) => res.send('Hello World!'));

// healthcheck
route.get('/health', limiter.rate250, healthcheck.healthcheck);

// all albums
route.get('/albums', limiter.rate250, album.allAlbums);

// by album id
route.get('/albums/:albumID', limiter.rate250, album.byAlbumID);

// all tracks in an album by id
route.get('/tracks?albumid={albumid}', limiter.rate100, track.multipleTracks);

// all tracks
route.get('/tracks', limiter.rate100, track.multipleTracks);

// by track id
route.get('/tracks/:trackID', limiter.rate250, track.byTrackID);



module.exports = route;

// original routes

// ID
// route.get('/id/:ShabadID', limiter.rate100, shabad.byID);

// acronym
// route.get('/line/:FirstLetters', limiter.rate100, shabad.byAcronym);

// line or keyword
// route.get('/verse/:Verse', limiter.rate100, shabad.byVerse);

// bani
// route.get('/bani/:Bani', limiter.rate100, category.byBani);

// raag
// route.get('raag/:Raag', limiter.rate100, category.ByRaag);

// author
// route.get('author/:Author',limiter.rate100, collection.byAuthor);

// kirtanis
// route.get('kirtani/:Kirtani',limiter.rate100, collection.byKirtani);
