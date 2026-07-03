import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHelper {
  static String hash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  static bool verify(String input, String hash) {
    return PasswordHelper.hash(input) == hash;
  }
}
