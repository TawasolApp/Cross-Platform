import 'package:image_picker/image_picker.dart';
import '../repositories/media_repository.dart';

class UploadDocument {
  final MediaRepository repository;

  UploadDocument(this.repository);

  Future<String> call(XFile documentFile) {
    print("Uploading document: ${documentFile.path}");
    return repository.uploadDocument(documentFile);
  }
}
