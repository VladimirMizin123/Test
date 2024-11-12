import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/user_photo_selection/user_photo_selection_event.dart';
import 'package:gymeats_mobile/bloc/user_photo_selection/user_photo_selection_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:image_picker/image_picker.dart';

class UserPhotoSelectionBloc
    extends Bloc<UserPhotoSelectionEvent, UserPhotoSelectionState> {
  UserPhotoSelectionBloc() : super(InitialState()) {
    on<ImageSelectionEvent>(_onImageSelection);
  }

  final ImagePicker _picker = ImagePicker();

  Future<File?> _getImage({required ImageSource source}) async {
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  _onImageSelection(
      ImageSelectionEvent event, Emitter<UserPhotoSelectionState> emit) async {
    if (event.imageFrom == StringUtils.takePhoto) {
      File? imageFile = await _getImage(source: ImageSource.camera);
      if (imageFile != null) {
        emit(GetImageState(image: imageFile));
      }
    } else {
      File? imageFile = await _getImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(GetImageState(image: imageFile));
      }
    }
  }
}
