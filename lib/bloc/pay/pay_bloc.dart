import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:payment_app/models/credit_card.dart';

part 'pay_event.dart';
part 'pay_state.dart';

class PayBloc extends Bloc<PayEvent, PayState> {
  PayBloc() : super(const PayState()) {
    on<OnSelectCard>(_onSelectCard);
    on<OnDeactivateCard>(_onDeactivateCard);
  }

  //Handler for OnSelectCard
  Future<void> _onSelectCard(OnSelectCard event, Emitter<PayState> emit) async {
    emit(state.copyWith(card: event.card, activeCard: true));
  }

  //Handler for OnDeactivateCard
  Future<void> _onDeactivateCard(
      OnDeactivateCard event, Emitter<PayState> emit) async {
    emit(state.copyWith(activeCard: false));
  }
}
