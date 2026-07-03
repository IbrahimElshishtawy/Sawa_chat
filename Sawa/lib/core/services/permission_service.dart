import '../models/user_model.dart';

class PermissionService {
  static bool canCreateGroup(UserModel user) {
    if (user.role == 'admin') return true;
    if (user.plan == 'pro') return true;
    // Free users might have a limit or be restricted
    return true; // Defaulting to true for now, but can be restricted
  }

  static bool canCreateChannel(UserModel user) {
    if (user.role == 'admin') return true;
    if (user.plan == 'pro') return true;
    return false; // Only pro or admin can create channels
  }

  static bool isPlanActive(UserModel user) {
    if (user.planExpiry == null) return true; // Lifetime or no expiry set
    return DateTime.now().isBefore(user.planExpiry!);
  }

  static int maxGroupMembers(UserModel user) {
    if (user.role == 'admin') return 10000;
    if (user.plan == 'pro') return 1000;
    return 50; // Free limit
  }

  static bool canMakeCall(UserModel user) {
    if (user.role == 'admin') return true;
    if (user.plan == 'pro') return true;
    return true;
  }

  static bool canSendMedia(UserModel user) {
    return true;
  }
}
