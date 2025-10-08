import db from "../config/db.js";

export const getHome = async (req, res) => {
  try {
    const result = await db.query(
      "SELECT * FROM books ORDER BY personal_rating DESC"
    );
    // console.log(result.rows);
    req.user ? console.log(req.user) : null;
    res.render("index.ejs", {
      books: result.rows,
      user: req.user ? req.user : false,
    });
  } catch (error) {
    console.log("error in fetching products:", error.message);
    res
      .status(500)
      .json({ success: false, message: "Server error handling home page" });
  }
};

export const getNotes = async (req, res) => {
  try {
    // console.log(req.user); //debug log
    const id = parseInt(req.params.id);
    const notes = await db.query(
      "SELECT * FROM notes WHERE book_id = $1 ORDER BY display_order ASC",
      [id]
    );
    const books = await db.query("SELECT * FROM books WHERE id = $1", [id]);
    const comments = await db.query(
      "SELECT c.id AS comment_id, c.comment, u.id AS user_id, u.fname, u.lname, u.image_url FROM comments c JOIN users u ON c.user_id = u.id WHERE c.book_id = $1",
      [id]
    );
    // console.log(books.rows[0]); // debug log
    // console.log(notes.rows); // debug log
    // console.log(comments.rows); //debug log
    res.render("notes.ejs", {
      notes:
        notes.rows.length > 0
          ? notes.rows
          : [{ notes: "No notes here yet 😭" }],
      books: books.rows,
      comments:
        comments.rows.length > 0
          ? comments.rows
          : [{ comment: "No comments yet! be the first to comment!" }],
      user: req.user ? req.user : false,
    });
  } catch (error) {
    console.log("error in fetching products:", error.message);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};
