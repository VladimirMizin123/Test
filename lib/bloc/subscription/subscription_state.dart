part of 'subscription_bloc.dart';

abstract class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

final class SubStatusLoader extends SubscriptionState {
  final bool loader;

  SubStatusLoader({required this.loader});
}

final class SubscriptionStatusState extends SubscriptionState {
  final SubscriptionStatusModel? status;

  SubscriptionStatusState({required this.status});
}

final class AddReceiptDetailsState extends SubscriptionState {}

final class SubscriptionStatusErrorState extends SubscriptionState {
  final String message;
  SubscriptionStatusErrorState({required this.message});
}

final class ReceiptDetailsSuccessState extends SubscriptionState {}

final class ReceiptDetailsLoadingState extends SubscriptionState {
  final bool isLoading;
  ReceiptDetailsLoadingState({required this.isLoading});
}
