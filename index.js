import dotenv from "dotenv";
dotenv.config();

import express from "express";
import bodyParser from "body-parser";

import passport from "passport";
import configurePassport from "./config/passport.js";
import session from "express-session";

import indexRoutes from "./routes/index.route.js";
import loginRoutes from "./routes/login.route.js";
import adminRoutes from "./routes/admin.route.js";

// Initialize express
const app = express();
const port = process.env.PORT;

// Initialize express-session
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: true,
    cookie: {
      maxAge: 1000 * 60 * 60 * 3,
    },
  })
);

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));
app.use(express.json());

// Initialize & Configure Passport
app.use(passport.initialize()); // Initialize passport
app.use(passport.session()); // Make sure it integrates express session
configurePassport();

// Routes
app.use("/", indexRoutes);
app.use("/", loginRoutes);
app.use("/admin", adminRoutes);

app.listen(port, () => {
  console.log(`App started at port: ${port}`);
});
