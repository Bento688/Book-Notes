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
const db = new pg.Client({
  user: "postgres",
  host: "localhost",
  database: "books",
  password: "Hironimusjnk4732",
  port: 5432,
});
db.connect();

app.get("/", async (req, res) => {
    const result = await db.query("SELECT title, description, isbn FROM books");
    console.log(result.rows);
    res.render("index.ejs", {
        books: result.rows
    });
});

app.listen(port, () => {
    console.log(`App started at port: ${port}`);
}); 
