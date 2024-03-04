import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_app/envs/envs.dart';
import 'package:payment_app/models/models.dart';

class StripeService {
  //Singleton
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static const String _secretKey = Keys.stripeKey;
  final String _publishableKey = Keys.publishableKey;

  final headerOptions = Options(
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      'Authorization': 'Bearer $_secretKey',
    },
  );

  void init() {
    Stripe.publishableKey = _publishableKey;
    Stripe.merchantIdentifier = 'Test';
    Stripe.instance.applySettings();
  }

  Future<StripeCustomResponse?> payWithExistingCard(
      {required String amount,
      required String currency,
      required String card}) async {
    try {
      final response = await _confirmPayment(
          amount: amount, currency: currency, paymentMethodId: 'Test');

      return response;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> payWithNewCard(
      {required String amount, required String currency}) async {
    try {
      final response = await _confirmPayment(
          amount: amount, currency: currency, paymentMethodId: 'Test');

      return response;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> payWithAppleOrGooglePay({
    required String amount,
    required String currency,
  }) async {
    try {
      // final token = await Stripe.instance.createApplePayToken(paymentRequest: ApplePayPaymentRequest(
      //   countryCode: 'US',
      //   currencyCode: 'USD',
      //   merchantIdentifier: 'Test',
      //   summaryItems: [
      //     ApplePayItem(label: 'Test', amount: amount),
      //   ],
      // ));

      return StripeCustomResponse(ok: true);
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<PaymentIntentResponse?> _createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      final dio = Dio();
      final data = {
        'amount': amount,
        'currency': currency,
      };
      final response = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions,
      );

      return PaymentIntentResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<StripeCustomResponse> _confirmPayment({
    required String amount,
    required String currency,
    required String paymentMethodId,
  }) async {
    try {
      final paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!.clientSecret,
          merchantDisplayName: 'Test',
        ),
      );

      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      return StripeCustomResponse(ok: true);
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
