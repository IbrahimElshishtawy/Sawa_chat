// ignore_for_file: file_names

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageOrVideo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<String> uploadFile(File file, String fileName) async {
    try {
      final ref = _storage.ref().child('chat_files/$fileName');
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error uploading file: $e");
    }
  }
}
