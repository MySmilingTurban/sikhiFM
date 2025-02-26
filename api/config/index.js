//const mariadb = require('mariadb');
require('dotenv').config();
exports.config = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    ssl: {
        ca: process.env.SSL_CA_PATH
    },
    port: 5001,
};



// // Connect and check for errors
// pool.getConnection((err, connection) => {
//     if(err){
//         if (err.code === 'PROTOCOL_CONNECTION_LOST'){
//             console.error('Database connection lost');
//         }
//         if (err.code === 'ER_CON_COUNT_ERROR'){
//             console.error('Database has too many connection');
//         }
//         if (err.code === 'ECONNREFUSED'){
//             console.error('Database connection was refused');
//         }
//     }
//     console.log('Connected to database');
//     if(connection) connection.release();

//     return;
// });

// module.exports = pool;