import express from "express";
import axios from "axios";
import bodyParser from "body-parser";
import pg from "pg";
import dotenv from "dotenv";

dotenv.config();
const app = express();
const port = process.env.PORT;

//Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

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

app.get("/", async (req, res) => {
    const result = await db.query("SELECT * FROM books ORDER BY id ASC");
    console.log(result.rows);
    res.render("index.ejs", {
        books: result.rows
    });
});

app.get("/notes/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    const notes = await db.query("SELECT * FROM notes WHERE book_id = $1", [id]);
    const books = await db.query("SELECT isbn, title FROM books WHERE id = $1", [id]);
    res.render("notes.ejs", {
        notes : notes.rows,
        books : books.rows
    });
});

app.listen(port, () => {
    console.log(`App started at port: ${port}`);
}); 
