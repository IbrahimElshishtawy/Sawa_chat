// ignore_for_file: deprecated_member_use

import 'package:chat_setup/core/models/call_model.dart';
import 'package:chat_setup/features/call/views/video_call_page.dart';
import 'package:chat_setup/features/call/views/voice_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/call/controllers/call_controller.dart';

class IncomingCallPage extends StatelessWidget {
  final CallModel call;
  const IncomingCallPage({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CallController>();

    final isVideo = call.type == CallType.video;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isVideo ? Icons.videocam : Icons.call, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'مكالمة واردة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'من: ${call.callerId}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          await ctrl.acceptCall(call.callId);

                          if (call.type == CallType.voice) {
                            Get.off(
                              () =>
                                  VoiceCallPage(channelName: call.channelName),
                            );
                          } else {
                            Get.off(
                              () =>
                                  VideoCallPage(channelName: call.channelName),
                            );
                          }
                        },

                        icon: const Icon(Icons.call),
                        label: const Text('قبول'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          await ctrl.rejectCall(call.callId);
                          Get.back();
                        },
                        icon: const Icon(Icons.call_end),
                        label: const Text('رفض'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
