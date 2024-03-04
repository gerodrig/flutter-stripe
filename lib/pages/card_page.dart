import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:payment_app/bloc/pay/pay_bloc.dart';
import 'package:payment_app/widgets/total_pay_button.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = context.watch<PayBloc>().state.card;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay'),
        leading: IconButton(
          icon: Icon(
              //? Call Event on Deactivate Card
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
          onPressed: () {
            context.read<PayBloc>().add(OnDeactivateCard());
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(),
          Hero(
            tag: card!.cardNumber,
            child: CreditCardWidget(
              cardNumber: card.cardNumber,
              expiryDate: card.expiryDate,
              cardHolderName: card.cardHolderName,
              cvvCode: card.cvv,
              showBackView: false,
              onCreditCardWidgetChange: (c) {},
            ),
          ),
          const Positioned(bottom: 0, child: TotalPayButton())
        ],
      ),
    );
  }
}
