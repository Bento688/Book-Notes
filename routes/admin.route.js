import express from "express";
import {
  adminPage,
  createBook,
  createNote,
  deleteBook,
  deleteNote,
  editNotePage,
  updateBook,
  updateNote,
} from "../controllers/admin.controller.js";

const router = express.Router();

// *** Admin Routes (Book & Notes)
router.get("/", adminPage);

// Book Edits
router.post("/create", createBook);

router.post("/update", updateBook);

router.post("/delete/:id", deleteBook);

// Notes Edits
router.get("/books/:id/notes", editNotePage);

router.post("/notes", createNote);

router.post("/notes/update", updateNote);

router.post("/notes/delete", deleteNote);

export default router;
