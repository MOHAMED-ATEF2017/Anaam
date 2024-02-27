import 'package:flutter/material.dart';
import 'package:tamara_flutter_sdk/tamara_checkout.dart';

class TamaraCheckoutScreen extends StatelessWidget {
  const TamaraCheckoutScreen({super.key, required this.checkoutUrl});
  final String checkoutUrl;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: TamaraCheckout(
       checkoutUrl,
        'successUrl',
        'failUrl',
        'cancelUrl',
        onPaymentSuccess: () {
          
        },
      ),
    );
  }
}
