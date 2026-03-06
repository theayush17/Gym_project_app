import express from "express";
import { createSubscription, verifyPayment } from "../controllers/subscriptionController.js";

const router = express.Router();

router.post("/create", createSubscription);
router.post("/verify", verifyPayment);

export default router;