import 'package:chat_setup/app/bindings/bindings.dart';
import 'package:chat_setup/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',

   
      themeMode: ThemeMode.light, // default

      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,

      initialBinding: InitialBinding(),
    );
  }
}
