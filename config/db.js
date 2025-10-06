import pg from "pg";
import dotenv from "dotenv";
dotenv.config();

const { Pool } = pg;

const isProduction = process.env.NODE_ENV === "production";

const connectionString = process.env.DATABASE_URL;

//Connect DB

const db = new Pool(
  isProduction
    ? {
        connectionString,
        ssl: { rejectUnauthorized: false },
      }
    : {
        user: process.env.DB_USER,
        host: process.env.DB_HOST,
        database: process.env.DB,
        password: process.env.DB_PASSWORD,
        port: parseInt(process.env.DB_PORT),
      }
);

db.connect()
  .then(() => console.log("✅ Connected to database"))
  .catch((err) => console.error("❌ Database connection error:", err.stack));

export default db;
