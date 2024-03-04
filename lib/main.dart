import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_app/bloc/pay/pay_bloc.dart';
import 'package:payment_app/pages/pages.dart';
import 'package:payment_app/services/stripe_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    StripeService().init();

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => PayBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stripe App',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'payment_completed': (_) => const PaymentCompletedPage(),
        },
        theme: ThemeData.light().copyWith(
            primaryColor: const Color(0xff284879),
            scaffoldBackgroundColor: const Color(0xff21232A)),
      ),
    );
  }
}
