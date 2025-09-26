import express from "express";
import bodyParser from "body-parser";
import db from "./config/db.js";
import dotenv from "dotenv";
import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import session from "express-session";

// Start dotenv
dotenv.config();

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
app.use(passport.initialize()); // Initialize passport
app.use(passport.session()); // Make sure it integrates express session
app.use(express.json());

// Home Routes
app.get("/", async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM books ORDER BY id ASC");
    console.log(result.rows);
    res.render("index.ejs", {
      books: result.rows,
    });
  } catch (error) {
    console.log("error in fetching products:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
});

app.get("/notes/:id", async (req, res) => {
  try {
    if (req.isAuthenticated()) {
      const id = parseInt(req.params.id);
      const notes = await db.query("SELECT * FROM notes WHERE book_id = $1", [
        id,
      ]);
      const books = await db.query("SELECT * FROM books WHERE id = $1", [id]);
      // console.log(books.rows[0]);
      // console.log(notes.rows);
      res.render("notes.ejs", {
        notes:
          notes.rows.length > 0
            ? notes.rows
            : [{ notes: "No notes here yet 😭" }],
        books: books.rows,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    console.log("error in fetching products:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
});

app.get("/admin", async (req, res) => {
  try {
    if (req.user && req.user.email === process.env.ADMIN_EMAIL) {
      const result = await db.query("SELECT * FROM books ORDER BY id ASC");
      res.render("admin.ejs", {
        books: result.rows,
      }); // or render an admin page
    } else {
      res.redirect("/");
    }
  } catch (error) {
    console.log("error in fetching products:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
});

// Login routes
app.get("/login", (req, res) => {
  res.render("login.ejs");
});

app.get(
  "/auth/google",
  passport.authenticate("google", {
    scope: ["profile", "email"],
  })
);

app.get(
  "/auth/google/callback",
  passport.authenticate("google", {
    successRedirect: "/",
    failureRedirect: "/",
  })
);

app.get("/logout", (req, res) => {
  req.logout(function (err) {
    if (err) {
      return next(err);
    }
    res.redirect("/");
  });
});

// Admin Routes
app.post("/create", async (req, res) => {
  console.log(req.body);
  const newBook = req.body;
  try {
    await db.query(
      "INSERT INTO books (title, description, isbn, personal_rating) VALUES($1, $2, $3, $4)",
      [newBook.bookname, newBook.desc, newBook.isbn, newBook.rating]
    );
    res.redirect("/admin");
  } catch (error) {
    console.error("Error in Create product:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
});

app.post("/update", async (req, res) => {
  console.log(req.body);
  const updatedValues = req.body;
  try {
    await db.query(
      `UPDATE books
      SET title = $2, description = $3, isbn = $4, personal_rating = $5
      WHERE id = $1`,
      [
        updatedValues.id,
        updatedValues.title,
        updatedValues.desc,
        updatedValues.isbn,
        updatedValues.rating,
      ]
    );
    res.redirect("/admin");
  } catch (error) {
    console.error("Error in Create product:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
});

app.post("/delete/:id", async (req, res) => {
  // console.log(req.params.id);
  const bookId = req.params.id;
  try {
    await db.query("DELETE FROM books WHERE id = $1", [bookId]);
    res.redirect("/admin");
  } catch (error) {
    console.error("Error in Create product:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
});

// Passport configurations
passport.use(
  "google",
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: "http://localhost:3000/auth/google/callback",
      userProfileURL: "https://www.googleapis.com/oauth2/v3/userinfo",
    },
    async (accessToken, refreshToken, profile, cb) => {
      console.log(profile);
      try {
        const email =
          profile.emails && profile.emails.length > 0
            ? profile.emails[0].value
            : null;

        if (!email) {
          return cb(new Error("No email returned from Google"), null);
        }
        const result = await db.query("SELECT * FROM users WHERE email = $1", [
          email,
        ]);
        if (result.rows.length == 0) {
          const newUser = await db.query(
            "INSERT INTO users (email, password) VALUES ($1, $2) RETURNING *",
            [email, "google"]
          );
          cb(null, newUser.rows[0]);
        } else {
          //Already have existing user
          cb(null, result.rows[0]);
        }
      } catch (err) {
        cb(err);
      }
    }
  )
);

passport.serializeUser((user, cb) => {
  return cb(null, user);
});

passport.deserializeUser((user, cb) => {
  return cb(null, user);
});

app.listen(port, () => {
  console.log(`App started at port: ${port}`);
});
