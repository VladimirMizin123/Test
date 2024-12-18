part of 'card_bloc.dart';

sealed class CardEvent {}

class ListAllCardEvent extends CardEvent {
  ListAllCardEvent();
}

class GetCardEvent extends CardEvent {
  final String cardId;
  GetCardEvent({required this.cardId});
}

class CreateOrEditCardEvent extends CardEvent {
  final Map<String, dynamic> card;
  final bool isAdd;
  CreateOrEditCardEvent({
    required this.card,
    required this.isAdd,
  });
}

class RemoveCardEvent extends CardEvent {
  final String id;
  final Function()? onSuccess;
  RemoveCardEvent({required this.id, this.onSuccess});
}

class SetDefaultCardEvent extends CardEvent {
  final String id;
  final Function()? onComplete;

  SetDefaultCardEvent({required this.id, this.onComplete});
}
