abstract class UserPhotoSelectionEvent{}

class ImageSelectionEvent extends UserPhotoSelectionEvent{
 final String imageFrom;

 ImageSelectionEvent({required this.imageFrom});
}
