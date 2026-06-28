import 'dart:io';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart'; // To use XFile
import 'package:mime/mime.dart';

class MediaRemoteDataSource {
  Future<String> uploadImage(XFile imageFile) async {
    final uri = Uri.parse('https://tawasolapp.me/api/media');
    var request = http.MultipartRequest('POST', uri);

    // Convert XFile to File using its path
    File file = File(imageFile.path);

    // Add the image file to the request
    var multipartFile = await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType(
        'image',
        'jpeg',
      ), // Adjust the type based on your image format
    );

    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    print(
      'Response for media upload is: ${response.statusCode}',
    ); // To check status code

    // Check if the response is successful
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse the response and return the URL
      final responseBody = await http.Response.fromStream(response);
      final Map<String, dynamic> data = jsonDecode(
        responseBody.body,
      ); // Parse JSON response
      final String imageUrl = data['url']; // Extract the URL from the response

      // Print the URL to the console
      print('Image uploaded successfully! URL: $imageUrl');

      return imageUrl; // Return the URL
    } else {
      throw Exception('Image upload failed: ${response.statusCode}');
    }
  }

  Future<String> uploadDocument(XFile docFile) async {
    print('📄 Uploading document...');
    print('→ File path: ${docFile.path}');
    print('→ File name: ${docFile.name}');
    final mimeType = lookupMimeType(docFile.path) ?? 'application/octet-stream';
    print('→ Mime type: $mimeType');

    final uri = Uri.parse('https://tawasolapp.me/api/media');
    var request = http.MultipartRequest('POST', uri);

    final file = await http.MultipartFile.fromPath(
      'file',
      docFile.path,
      contentType: MediaType.parse(mimeType),
      filename: docFile.name,
    );

    request.files.add(file);

    try {
      final response = await request.send();
      print('⬅️ Response status: ${response.statusCode}');
      final responseBody = await http.Response.fromStream(response);
      print('⬅️ Response body: ${responseBody.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(responseBody.body);
        final String fileUrl = data['url'];
        print('✅ Document uploaded: $fileUrl');
        return fileUrl;
      } else {
        throw Exception('❌ Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Upload exception: $e');
      rethrow;
    }
  }
}
