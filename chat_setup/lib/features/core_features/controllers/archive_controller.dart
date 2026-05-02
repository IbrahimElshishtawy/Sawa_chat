import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/archive_service.dart';

class ArchiveController extends GetxController {
  final ArchiveService _service = ArchiveService();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> archiveChat(String chatId) async {
    await _service.setArchived(userId: userId, chatId: chatId, archived: true);
  }

  Future<void> unarchiveChat(String chatId) async {
    await _service.setArchived(userId: userId, chatId: chatId, archived: false);
  }

  Stream archivedChats() => _service.archivedChats(userId);
  Stream activeChats() => _service.activeChats(userId);
}
