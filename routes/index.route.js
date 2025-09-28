import express from "express";
import { getHome, getNotes } from "../controllers/index.controller.js";

const router = express.Router();

// Home Routes
router.get("/", getHome);

router.get("/notes/:id", getNotes);

export default router;
