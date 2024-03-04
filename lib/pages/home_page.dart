// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:payment_app/pages/pages.dart';
import 'package:payment_app/services/stripe_service.dart';
import 'package:payment_app/widgets/total_pay_button.dart';

import '../bloc/pay/pay_bloc.dart';
import '../data/cards.dart';
import '../helpers/helpers.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final stripeService = StripeService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final payBloc = context.read<PayBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              showLoading(context);
              final amount = payBloc.state.amountPayString;
              final currency = payBloc.state.currency;

              try {
                final response = await stripeService.payWithNewCard(
                    amount: amount, currency: currency);

                Navigator.pop(context);

                if (response.ok) {
                  showAlert(context, 'Success', 'Payment Successful');
                } else {
                  showAlert(context, 'Error', response.msg);
                }
              } catch (e) {
                showAlert(context, 'Error', e.toString());
              }
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            top: 200,
            child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: cards.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) {
                  final card = cards[i];
                  return GestureDetector(
                    onDoubleTap: () {
                      context.read<PayBloc>().add(OnSelectCard(card));
                      Navigator.push(
                          context, navigateFadeIn(context, const CardPage()));
                    },
                    child: Hero(
                      tag: card.cardNumber,
                      child: CreditCardWidget(
                        cardNumber: card.cardNumberHidden,
                        expiryDate: card.expiryDate,
                        cardHolderName: card.cardHolderName,
                        cvvCode: card.cvv,
                        showBackView: false,
                        isHolderNameVisible: true,
                        onCreditCardWidgetChange: (c) {},
                      ),
                    ),
                  );
                }),
          ),
          const Positioned(
            bottom: 0,
            child: TotalPayButton(),
          )
        ],
      ),
    );
  }
}
