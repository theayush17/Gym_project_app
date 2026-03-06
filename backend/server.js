import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import subscriptionRoutes from "./routes/subscription.js";

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/subscription", subscriptionRoutes);

app.listen(process.env.PORT, () => {
  console.log(`Server running on port ${process.env.PORT}`);
});