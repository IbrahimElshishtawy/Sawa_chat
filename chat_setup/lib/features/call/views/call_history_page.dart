import 'package:chat_setup/core/models/call_model.dart';
import 'package:chat_setup/features/call/controllers/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CallController>();

    return Scaffold(
      appBar: AppBar(title: const Text('سجل المكالمات')),
      body: Obx(() {
        if (ctrl.calls.isEmpty) {
          return const Center(child: Text('لا توجد مكالمات'));
        }

        return ListView.builder(
          itemCount: ctrl.calls.length,
          itemBuilder: (_, i) {
            final call = ctrl.calls[i];
            final missed = ctrl.isMissed(call);

            return ListTile(
              leading: Icon(
                call.type == CallType.voice ? Icons.call : Icons.videocam,
                color: missed ? Colors.red : Colors.green,
              ),
              title: Text(missed ? 'مكالمة فائتة' : 'مكالمة ${call.type.name}'),
              subtitle: Text(call.createdAt.toString()),
              trailing: missed
                  ? const Icon(Icons.call_missed, color: Colors.red)
                  : const Icon(Icons.call_made),
            );
          },
        );
      }),
    );
  }
}
