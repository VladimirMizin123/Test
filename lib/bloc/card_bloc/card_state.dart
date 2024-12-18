part of 'card_bloc.dart';

sealed class CardState {}

final class CardInitial extends CardState {}

final class CardLoadingState extends CardState {
  final bool isLoading;
  CardLoadingState({required this.isLoading});
}

final class CardAddLoadingState extends CardState {
  final bool isLoad;
  CardAddLoadingState({required this.isLoad});
}

final class CardRemoveLoadingState extends CardState {
  final bool isLoad;
  CardRemoveLoadingState({required this.isLoad});
}

final class SetDefaultCardLoader extends CardState {
  final bool isLoad;
  SetDefaultCardLoader({required this.isLoad});
}

final class CardFetchSuccessState extends CardState {
  final List<StripeCard> cardList;
  CardFetchSuccessState({required this.cardList});
}

final class CardSuccessState extends CardState {}

final class CardRemoveSuccessState extends CardState {}
