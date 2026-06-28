
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/domain/repositories/media_repository.dart';

class UploadImageUseCase {
  final MediaRepository mediaRepository;

  UploadImageUseCase({required this.mediaRepository});

  Future<String> execute(XFile imageFile) {
    return mediaRepository.uploadImage(imageFile);
  }
}
