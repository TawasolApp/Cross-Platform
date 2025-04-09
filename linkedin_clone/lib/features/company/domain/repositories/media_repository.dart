
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/data/datasources/media_remote_data_source.dart.dart';

class MediaRepository {
  final MediaRemoteDataSource mediaRemoteDataSource;

  MediaRepository({required this.mediaRemoteDataSource});

  Future<String> uploadImage(XFile imageFile) {
    return mediaRemoteDataSource.uploadImage(imageFile);
  }
}
