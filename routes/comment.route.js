import express from "express";
import {
  createComment,
  deleteComment,
} from "../controllers/comment.controller.js";

const router = express.Router();

router.post("/", createComment);

router.post("/delete", deleteComment);

export default router;
