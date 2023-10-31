import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';

abstract class AccountEvent {}

/// Get All Program Event ===============================================================
class GetAllProgramEvent extends AccountEvent {}

/// Get Program Info Event ===============================================================
class GetProgramInfoEvent extends AccountEvent {
  final String programId;

  GetProgramInfoEvent(this.programId);
}
