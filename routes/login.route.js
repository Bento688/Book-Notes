import express from "express";
import {
  googleCallBack,
  googleLogin,
  userLogin,
  userLogout,
} from "../controllers/login.controller.js";

const router = express.Router();

// Login routes
router.get("/login", userLogin);

router.get("/auth/google", googleLogin);

router.get("/auth/google/callback", googleCallBack);

router.get("/logout", userLogout);

export default router;
