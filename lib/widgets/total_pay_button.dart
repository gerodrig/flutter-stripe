import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payment_app/bloc/pay/pay_bloc.dart';
import 'package:payment_app/helpers/helpers.dart';
import 'package:payment_app/services/stripe_service.dart';

class TotalPayButton extends StatelessWidget {
  const TotalPayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final payBloc = context.read<PayBloc>().state;

    return Container(
      width: width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(' \$ ${payBloc.amountPay} ${payBloc.currency}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          BlocBuilder<PayBloc, PayState>(builder: (context, state) {
            return _PayButton(state);
          }),
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  final PayState state;
  const _PayButton(this.state);

  @override
  Widget build(BuildContext context) {
    return state.activeCard
        ? buildCardButton(context)
        : buildAppleAndGooglePay(context);
  }

  Widget buildCardButton(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: const Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.solidCreditCard, color: Colors.white),
          SizedBox(width: 10),
          Text('Pay', style: TextStyle(color: Colors.white, fontSize: 23)),
        ],
      ),
      onPressed: () async {
        showLoading(context);
        final stripeService = StripeService();
        final state = context.read<PayBloc>().state;
        final card = state.card;

        final response = await stripeService.payWithExistingCard(
            amount: state.amountPayString,
            currency: state.currency,
            card: card!.cardNumber);

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      },
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
              Platform.isAndroid
                  ? FontAwesomeIcons.google
                  : FontAwesomeIcons.apple,
              color: Colors.white),
          //space
          const SizedBox(width: 10),
          const Text('Pay',
              style: TextStyle(color: Colors.white, fontSize: 23)),
        ],
      ),
      onPressed: () async {
        final stripeService = StripeService();
        final state = context.read<PayBloc>().state;

        final response = await stripeService.payWithAppleOrGooglePay(
            amount: state.amountPayString, currency: state.currency);
      },
    );
  }
}
