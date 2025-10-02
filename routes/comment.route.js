import express from "express";
import db from "../config/db.js";

const router = express.Router();

router.post("/", async (req, res) => {
  if (req.isAuthenticated()) {
    console.log(req.body);
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
});

export default router;
