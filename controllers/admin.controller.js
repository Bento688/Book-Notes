import dotenv from "dotenv";
dotenv.config();
import db from "../config/db.js";

export const adminPage = async (req, res) => {
  try {
    if (req.user && req.user.email === process.env.ADMIN_EMAIL) {
      const books = await db.query("SELECT * FROM books ORDER BY id ASC");
      const notes = await db.query("SELECT * FROM notes ORDER BY book_id ASC");
      // console.log(notes.rows);
      res.render("admin.ejs", {
        books: books.rows,
        notes: notes.rows,
      }); // or render an admin page
    } else {
      res.redirect("/");
    }
  } catch (error) {
    console.log("error in fetching products:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};

export const createBook = async (req, res) => {
  if (req.isAuthenticated()) {
    // console.log(req.body);
    const newBook = req.body;
    try {
      await db.query(
        "INSERT INTO books (title, description, isbn, personal_rating, author_name) VALUES($1, $2, $3, $4, $5)",
        [
          newBook.bookname,
          newBook.desc,
          newBook.isbn,
          newBook.rating,
          newBook.authorName,
        ]
      );
      res.redirect("/admin");
    } catch (error) {
      console.error("Error in Create product:", error.message);
      res.status(500).json({ success: false, message: "Server Error" });
    }
  } else {
    res.redirect("/");
  }
};

export const updateBook = async (req, res) => {
  if (req.isAuthenticated()) {
    // console.log(req.body);
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
          updatedValues.authorName,
        ]
      );
      res.redirect("/admin");
    } catch (error) {
      console.error("Error in Create product:", error.message);
      res.status(500).json({ success: false, message: "Server Error" });
    }
  } else {
    res.redirect("/");
  }
};

export const deleteBook = async (req, res) => {
  if (req.isAuthenticated()) {
    // console.log(req.params.id);
    const bookId = req.params.id;
    try {
      await db.query("DELETE FROM books WHERE id = $1", [bookId]);
      res.redirect("/admin");
    } catch (error) {
      console.error("Error in Create product:", error.message);
      res.status(500).json({ success: false, message: "Server Error" });
    }
  } else {
    res.redirect("/");
  }
};

export const editNotePage = async (req, res) => {
  if (req.isAuthenticated()) {
    // console.log(req.params.id);
    const { id } = req.params;
    try {
      const bookTitle = await db.query(
        "SELECT title, id FROM books WHERE id = $1",
        [id]
      );
      const notes = await db.query(
        "SELECT * FROM notes WHERE book_id = $1 ORDER BY display_order ASC",
        [id]
      );
      // console.log(notes.rows);
      // console.log(bookTitle.rows);
      res.render("editnote.ejs", {
        notes: notes.rows,
        bookTitle: bookTitle.rows[0],
      });
    } catch (error) {
      console.log("error in fetching products:", error.message);
      res.status(500).json({ success: false, message: "Error Fetching Notes" });
    }
  } else {
    res.redirect("/");
  }
};

export const createNote = async (req, res) => {
  if (req.isAuthenticated()) {
    try {
      // console.log(req.body);
      const { book_id, content } = req.body;
      await db.query(
        "INSERT INTO notes (notes, book_id, display_order) SELECT $1, $2, COALESCE(MAX(display_order), 0) + 1 FROM notes WHERE book_id = $2 RETURNING *",
        [content, book_id]
      );
      res.redirect(`/admin/books/${book_id}/notes`);
    } catch (error) {
      console.log("error in fetching products:", error.message);
      res.status(500).json({ success: false, message: "Error Creating Notes" });
    }
  } else {
    res.redirect("/");
  }
};

export const updateNote = async (req, res) => {
  if (req.isAuthenticated()) {
    try {
      const { id, note, book_id } = req.body;
      // console.log(id, note);
      await db.query("UPDATE notes SET notes = $1 WHERE id = $2", [note, id]);
      res.redirect(`/admin/books/${book_id}/notes`);
    } catch (error) {
      console.log("error in fetching products:", error.message);
      res.status(500).json({ success: false, message: "Error Updating Notes" });
    }
  } else {
    res.redirect("/");
  }
};

export const deleteNote = async (req, res) => {
  if (req.isAuthenticated()) {
    try {
      // console.log(req.body);
      const { book_id, id } = req.body;
      await db.query("DELETE FROM notes WHERE id = $1", [id]);
      res.redirect(`/admin/books/${book_id}/notes`);
    } catch (error) {
      console.log("error in deleting note:", error.message);
      res.status(500).json({ success: false, message: "Error Deleting Notes" });
    }
  } else {
    res.redirect("/");
  }
};
