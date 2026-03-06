import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  Function(String paymentId)? onSuccess;
  Function(String error)? onError;

  RazorpayService() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      onSuccess?.call(response.paymentId ?? "");
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      onError?.call(response.message ?? "Payment Failed");
    });
  }

  void startSubscription({
    required String key,
    required String subscriptionId,
    required String name,
    required String description,
  }) {
    var options = {
      'key': key,
      'subscription_id': subscriptionId,
      'name': name,
      'description': description,
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}