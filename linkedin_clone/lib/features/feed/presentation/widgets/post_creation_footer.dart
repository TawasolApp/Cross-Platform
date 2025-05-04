import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/upload_image.dart';
import 'package:file_picker/file_picker.dart';
import '../../../company/domain/repositories/media_repository.dart';
import 'package:provider/provider.dart';

class PostCreationFooter extends StatelessWidget {
  final void Function(String imageUrl) onImageUploaded;
  const PostCreationFooter({super.key, required this.onImageUploaded});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: isDarkMode ? Colors.orange.shade200 : Colors.orange,
            ),
            const SizedBox(width: 5),
            Text(
              "Rewrite with AI",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.image_outlined),
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? pickedFile = await picker.pickImage(
              source: ImageSource.gallery,
            );
            if (pickedFile != null) {
              try {
                final imageUrl = await uploadImage(pickedFile);
                onImageUploaded(imageUrl);
                print('Image uploaded to: $imageUrl');
              } catch (e) {
                print('Upload failed: $e');
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.description_outlined),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'doc', 'docx'],
            );

            if (result != null && result.files.single.path != null) {
              final path = result.files.single.path!;
              final pickedFile = XFile(path);
              try {
                final mediaRepo = Provider.of<MediaRepository>(
                  context,
                  listen: false,
                );
                final url = await mediaRepo.uploadDocument(pickedFile);
                onImageUploaded(url);
                print('📄 Document uploaded to: $url');
              } catch (e) {
                print('❌ Document upload failed: $e');
              }
            } else {
              print('⚠️ No document selected');
            }
          },
        ),
      ],
    );
  }
}
