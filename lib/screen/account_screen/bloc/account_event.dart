import 'dart:io';

import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';

abstract class AccountEvent {}

/// Get All Program Event ===============================================================
class GetAllProgramEvent extends AccountEvent {}

/// Get All Program Event ===============================================================
class GetCurrentProgramEvent extends AccountEvent {}

/// Get Program Info Event ===============================================================
class GetProgramInfoEvent extends AccountEvent {
  final String programId;

  GetProgramInfoEvent(this.programId);
}

/// Update Program Diet Event ===============================================================

class UpdateProgramDietEvent extends AccountEvent {
  final String programId;

  UpdateProgramDietEvent(this.programId);
}

/// Get Profile Image Event ===============================================================
class GetProfileImageEvent extends AccountEvent {}

/// Get Profile Details Event ===============================================================
class GetProfileDetailsEvent extends AccountEvent {}

/// Update Profile Details Event ===============================================================
class UpdateProfileDetailsEvent extends AccountEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final int goal;
  final int weight;
  final int targetWeight;
  final double heightInCm;
  final DateTime birthDate;
  final String gender;

  UpdateProfileDetailsEvent({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.goal,
    required this.weight,
    required this.targetWeight,
    required this.heightInCm,
    required this.birthDate,
    required this.gender,
  });
}

/// Update Profile Details Event ===============================================================
class UpdateProfileImageEvent extends AccountEvent {
  final File imageFile;

  UpdateProfileImageEvent({required this.imageFile});
}

/// Select Image from device  Event ===============================================================

class GetSelectedImagePathEvent extends AccountEvent {
  final File? imagePath;
  GetSelectedImagePathEvent({required this.imagePath});
}

/// Change Profile Password Event ===============================================================
class ChangeProfilePasswordEvent extends AccountEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String email;

  ChangeProfilePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.email,
  });
}

/// Get Unit info Event ===============================================================
class GetUnitInfoEvent extends AccountEvent {}

/// Update Unit info Event ===============================================================
class UpdateUnitInfoEvent extends AccountEvent {
  final String unitId;
  final int weightType;
  final int heightType;
  final int energyType;
  final int waterType;

  UpdateUnitInfoEvent({
    required this.unitId,
    required this.weightType,
    required this.heightType,
    required this.energyType,
    required this.waterType,
  });
}
