import pg from "pg";
import dotenv from "dotenv";
dotenv.config();

//Connect DB
const dbPw = process.env.DB_PASSWORD;
const dbDb = process.env.DB;
const dbUser = process.env.DB_USER;
const dbPort = process.env.DB_PORT;
const dbHost = process.env.DB_HOST;

const db = new pg.Client({
  user: dbUser,
  host: dbHost,
  database: dbDb,
  password: dbPw,
  port: parseInt(dbPort),
});
db.connect();

export default db;
