import dotenv from "dotenv";
dotenv.config();

import express from "express";
import passport from "passport";

import configurePassport from "./config/passport.js";
import sessionConfig from "./config/session.js";

import indexRoutes from "./routes/index.route.js";
import loginRoutes from "./routes/login.route.js";
import adminRoutes from "./routes/admin.route.js";

// Initialize express
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(express.static("public"));
app.use(express.json());

// Initialize & Configure Passport and express-session
app.use(sessionConfig);
app.use(passport.initialize()); // Initialize passport
app.use(passport.session()); // Make sure it integrates express session
configurePassport(); // Configure passport

// Routes
app.use("/", indexRoutes);
app.use("/auth", loginRoutes);
app.use("/admin", adminRoutes);

app.listen(port, () => {
  console.log(`App started at port: ${port}`);
});
