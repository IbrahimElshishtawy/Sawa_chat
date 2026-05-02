import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/user_model.dart';

class UserService {
  final _users = FirebaseFirestore.instance.collection('users');

  /// 🔹 Get single user
  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.id, doc.data()!);
  }

  /// 🔹 UPDATE user
  Future<void> updateUser(UserModel user) async {
    // التحقق من أن الإيميل أو الرقم ليس مكررًا قبل التحديث
    final emailExists =
        await _users.where('email', isEqualTo: user.email).get();

    final phoneExists =
        await _users.where('phone', isEqualTo: user.phone).get();

    if (emailExists.docs.isNotEmpty) {
      throw Exception('Email already exists');
    }

    if (phoneExists.docs.isNotEmpty) {
      throw Exception('Phone number already exists');
    }

    await _users.doc(user.id).update(user.toMap());
  }

  Future<List<UserModel>> getAllUsers() async {
    final snap = await FirebaseFirestore.instance.collection('users').get();

    // إرجاع المستخدمين الذين لم يتم حذفهم فقط
    return snap.docs
        .where(
          (d) => d.data().containsKey('email') && d.data().containsKey('phone'),
        ) // التأكد من وجود الإيميل والرقم
        .map((d) => UserModel.fromMap(d.id, d.data()))
        .toList();
  }

  // ======================
  // Social (Follow/Unfollow)
  // ======================

  Future<void> followUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) return;

    final batch = FirebaseFirestore.instance.batch();

    // Add to current user's following
    batch.set(
      _users.doc(currentUserId).collection('following').doc(targetUserId),
      {'timestamp': FieldValue.serverTimestamp()},
    );

    // Add to target user's followers
    batch.set(
      _users.doc(targetUserId).collection('followers').doc(currentUserId),
      {'timestamp': FieldValue.serverTimestamp()},
    );

    // Increment counts
    batch.update(_users.doc(currentUserId), {
      'followingCount': FieldValue.increment(1),
    });
    batch.update(_users.doc(targetUserId), {
      'followersCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) return;

    final batch = FirebaseFirestore.instance.batch();

    // Remove from current user's following
    batch.delete(
      _users.doc(currentUserId).collection('following').doc(targetUserId),
    );

    // Remove from target user's followers
    batch.delete(
      _users.doc(targetUserId).collection('followers').doc(currentUserId),
    );

    // Decrement counts
    batch.update(_users.doc(currentUserId), {
      'followingCount': FieldValue.increment(-1),
    });
    batch.update(_users.doc(targetUserId), {
      'followersCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final doc = await _users
        .doc(currentUserId)
        .collection('following')
        .doc(targetUserId)
        .get();
    return doc.exists;
  }

  Future<List<UserModel>> getFollowers(String userId, {int limit = 20}) async {
    final snap = await _users
        .doc(userId)
        .collection('followers')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    List<UserModel> followers = [];
    for (var doc in snap.docs) {
      final user = await getUser(doc.id);
      if (user != null) followers.add(user);
    }
    return followers;
  }

  Future<List<UserModel>> getFollowing(String userId, {int limit = 20}) async {
    final snap = await _users
        .doc(userId)
        .collection('following')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    List<UserModel> following = [];
    for (var doc in snap.docs) {
      final user = await getUser(doc.id);
      if (user != null) following.add(user);
    }
    return following;
  }

  // ======================
  // Contact Sync
  // ======================

  Future<List<UserModel>> syncContacts() async {
    final status = await Permission.contacts.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Contacts permission not granted');
    }

    final contacts = await ContactsService.getContacts();
    final phoneNumbers = contacts
        .expand((c) => c.phones ?? [])
        .map((p) => p.value?.replaceAll(RegExp(r'\D'), ''))
        .where((p) => p != null && p.isNotEmpty)
        .cast<String>()
        .toSet();

    if (phoneNumbers.isEmpty) return [];

    final matchingUsers = <UserModel>[];
    final phoneList = phoneNumbers.toList();

    // Firestore whereIn limit is 30
    for (var i = 0; i < phoneList.length; i += 30) {
      final chunk = phoneList.sublist(
        i,
        i + 30 > phoneList.length ? phoneList.length : i + 30,
      );
      final snap = await _users.where('phone', whereIn: chunk).get();
      matchingUsers.addAll(
        snap.docs.map((d) => UserModel.fromMap(d.id, d.data())),
      );
    }

    return matchingUsers;
  }
}
