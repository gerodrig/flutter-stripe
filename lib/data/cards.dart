import 'package:payment_app/models/credit_card.dart';

final List<CustomCreditCard> cards = <CustomCreditCard>[
  const CustomCreditCard(
      cardNumberHidden: '4242',
      cardNumber: '4242424242424242',
      brand: 'visa',
      cvv: '213',
      expiryDate: '01/25',
      cardHolderName: 'Benito Martinez'),
  const CustomCreditCard(
      cardNumberHidden: '5555',
      cardNumber: '5555555555554444',
      brand: 'mastercard',
      cvv: '213',
      expiryDate: '01/25',
      cardHolderName: 'Mimi Martinez'),
  const CustomCreditCard(
      cardNumberHidden: '3782',
      cardNumber: '378282246310005',
      brand: 'american express',
      cvv: '2134',
      expiryDate: '01/25',
      cardHolderName: 'Dulce Martinez'),
];
