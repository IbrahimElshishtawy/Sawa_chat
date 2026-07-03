// ignore_for_file: file_names

import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AudioRecordingService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;

  // بدء التسجيل
  Future<void> startRecording() async {
    await _recorder.openRecorder();
    await _recorder.startRecorder(toFile: 'audio_recording.aac');
    isRecording = true;
  }

  // إيقاف التسجيل
  Future<String?> stopRecording() async {
    if (isRecording) {
      final path = await _recorder.stopRecorder();
      isRecording = false;
      return path;
    }
    return null;
  }

  // رفع التسجيل الصوتي إلى Firebase
  Future<String> uploadAudio(String filePath) async {
    final File audioFile = File(filePath);
    try {
      final ref = FirebaseStorage.instance.ref().child('chat_audio/audio.aac');
      final uploadTask = await ref.putFile(audioFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error uploading audio file: $e");
    }
  }
}
