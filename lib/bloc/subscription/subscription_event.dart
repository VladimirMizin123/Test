// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subscription_bloc.dart';

abstract class SubscriptionEvent {}

class FetchSubscriptionEvent extends SubscriptionEvent {
  FetchSubscriptionEvent();
}

class AddReceiptDetailsEvent extends SubscriptionEvent {
  final Map<String, dynamic> requestData;
  AddReceiptDetailsEvent({required this.requestData});
}
