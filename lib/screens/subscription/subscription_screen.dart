import 'package:flutter/material.dart';
import '../../services/razorpay_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late RazorpayService _razorpayService;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService();

    _razorpayService.onSuccess = (paymentId) {
      print("Payment Success: $paymentId");
      // 🔥 Call backend verify API here
    };

    _razorpayService.onError = (error) {
      print("Payment Failed: $error");
    };
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subscription")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _razorpayService.startSubscription(
              key: "YOUR_RAZORPAY_KEY",
              subscriptionId: "subscription_from_backend",
              name: "EcoGym",
              description: "Monthly Gym Plan",
            );
          },
          child: const Text("Subscribe ₹500/month"),
        ),
      ),
    );
  }
}