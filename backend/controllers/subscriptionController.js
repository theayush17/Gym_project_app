import razorpay from "../utils/razorpay.js";
import crypto from "crypto";

export const createSubscription = async (req, res) => {
  try {
    const options = {
      plan_id: "YOUR_PLAN_ID",
      customer_notify: 1,
      total_count: 12
    };

    const subscription = await razorpay.subscriptions.create(options);
    res.json(subscription);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const verifyPayment = (req, res) => {
  const { razorpay_payment_id, razorpay_subscription_id, razorpay_signature } = req.body;

  const body = razorpay_payment_id + "|" + razorpay_subscription_id;

  const expectedSignature = crypto
    .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET)
    .update(body.toString())
    .digest("hex");

  if (expectedSignature === razorpay_signature) {
    res.json({ status: "success" });
  } else {
    res.status(400).json({ status: "failed" });
  }
};