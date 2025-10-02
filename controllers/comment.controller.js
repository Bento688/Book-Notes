import db from "../config/db.js";

export const createComment = async (req, res) => {
  if (req.isAuthenticated()) {
    // console.log(req.body);
    const comment = req.body;
    try {
      const result = await db.query(
        "INSERT INTO comments(comment, user_id, book_id) VALUES($1, $2, $3)",
        [comment.comment, comment.user_id, comment.book_id]
      );
      res.redirect(`/notes/${req.body.book_id}`);
    } catch (error) {
      console.log("error in inserting comment:", error.message);
      res.status(500).json({ success: false, message: "Server Error" });
    }
  } else {
    res.redirect("/auth/login");
  }
};

export const deleteComment = async (req, res) => {
  if (req.isAuthenticated()) {
    // console.log(req.body);
    try {
      await db.query("DELETE FROM comments WHERE id = $1", [
        req.body.comment_id,
      ]);
      res.redirect(`/notes/${req.body.book_id}`);
    } catch (error) {
      console.log("error in deleting comment:", error.message);
      res.status(500).json({ success: false, message: "Server Error" });
    }
  } else {
    res.redirect(`/notes/${req.body.book_id}`);
  }
};
