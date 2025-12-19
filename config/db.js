import pg from "pg";
import dotenv from "dotenv";
dotenv.config();

const { Pool } = pg;

const dbConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
};

// If running in Cloud Run (socket connection), use the socket
if (process.env.INSTANCE_CONNECTION_NAME) {
  dbConfig.host = `/cloudsql/${process.env.INSTANCE_CONNECTION_NAME}`;
} else {
  // Local development fallback
  dbConfig.host = process.env.DB_HOST || "localhost";
  dbConfig.port = process.env.DB_PORT || 5432;
}

const db = new Pool(dbConfig);
export default db;
