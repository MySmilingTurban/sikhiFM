/**
 * config for SikhiFM Database
 * @const {JSON} config
 */
export const config = {
  host: 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root',
  database: process.env.NODE_ENV === 'development' ? 'sikhifm_db' : 'sikhifm_db',
  port: process.env.DB_PORT || 3306,
};
