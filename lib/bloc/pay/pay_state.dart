part of 'pay_bloc.dart';

@immutable
class PayState {
  final double amountPay;
  final String currency;
  final bool activeCard;
  final CustomCreditCard? card;

  String get amountPayString => '${(amountPay * 100).floor()}';

  const PayState(
      {this.amountPay = 375.55,
      this.currency = 'CAD',
      this.activeCard = false,
      this.card});

  PayState copyWith(
          {double? amountPay,
          String? currency,
          bool? activeCard,
          CustomCreditCard? card}) =>
      PayState(
          amountPay: amountPay ?? this.amountPay,
          currency: currency ?? this.currency,
          activeCard: activeCard ?? this.activeCard,
          card: card ?? this.card);
}
