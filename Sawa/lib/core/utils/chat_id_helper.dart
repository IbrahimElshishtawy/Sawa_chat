class ChatIdHelper {
  static String privateId(String a, String b) {
    final sorted = [a, b]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
