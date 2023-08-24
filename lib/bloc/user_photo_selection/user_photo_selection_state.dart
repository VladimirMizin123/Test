import 'dart:io';

abstract class UserPhotoSelectionState{}

class InitialState extends UserPhotoSelectionState{}

class GetImageState extends UserPhotoSelectionState{
  final File image;

  GetImageState({required this.image});
}