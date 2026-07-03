// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:chat_setup/features/chat/controllers/chat_controller.dart';
// import '../../widgets/dialogs/password_dialog.dart';
// import 'chat_page.dart';

// class PrivateChatLockPage extends StatelessWidget {
//   final String chatId;
//   final String otherUserId;
//   final String otherUserName;

//   const PrivateChatLockPage({
//     super.key,
//     required this.chatId,
//     required this.otherUserId,
//     required this.otherUserName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = Get.find<ChatController>();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Locked Chat')),
//       body: Center(
//         child: ElevatedButton(
//           child: const Text('Unlock Chat'),
//           onPressed: () async {
//             final password = await showPasswordDialog(context);
//             if (password == null) return;

//             final allowed = ctrl.canOpenChat(chatId, password);

//             if (allowed) {
//               Get.off(
//                 () => ChatPage(
//                   otherUserId: otherUserId,
//                   otherUserName: otherUserName,
//                 ),
//               );
//             } else {
//               Get.snackbar('Error', 'Wrong password');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
