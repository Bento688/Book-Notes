import session from "express-session";
import pgSession from "connect-pg-simple"; // Import
import db from "./db.js"; // Import your existing pool

const PgSession = pgSession(session);

const sessionConfig = session({
  store: new PgSession({
    pool: db, // Use your existing DB connection
    tableName: "session", // Table to store sessions
  }),
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false, // Changed to false for storage efficiency
  cookie: {
    maxAge: 1000 * 60 * 60 * 3, // 3 hours
    secure: process.env.NODE_ENV === "production", // Secure in prod
  },
});

export default sessionConfig;
