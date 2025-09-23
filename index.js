import express from "express";
import bodyParser from "body-parser";
import db from "./config/db.js";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const port = process.env.PORT;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

// Routes
app.get("/", async (req, res) => {
  const result = await db.query("SELECT * FROM books ORDER BY id ASC");
  console.log(result.rows);
  res.render("index.ejs", {
    books: result.rows,
  });
});

app.get("/login", async (req, res) => {
  res.render("login.ejs");
});

app.get("/notes/:id", async (req, res) => {
  const id = parseInt(req.params.id);
  const notes = await db.query("SELECT * FROM notes WHERE book_id = $1", [id]);
  const books = await db.query("SELECT * FROM books WHERE id = $1", [id]);
  // console.log(books.rows[0]);
  // console.log(notes.rows);
  res.render("notes.ejs", {
    notes:
      notes.rows.length > 0 ? notes.rows : [{ notes: "No notes here yet 😭" }],
    books: books.rows,
  });
});

app.listen(port, () => {
  console.log(`App started at port: ${port}`);
});
