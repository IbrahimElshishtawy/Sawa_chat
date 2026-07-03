import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔄 Auth state
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// 🔐 LOGIN
  Future<User> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// 📝 REGISTER
  Future<User> register({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        ...userData,
        'uid': cred.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// ❗ Error Mapper (موحد)
  FirebaseAuthException _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return FirebaseAuthException(
          code: e.code,
          message: 'لا يوجد حساب بهذا البريد الإلكتروني',
        );
      case 'wrong-password':
      case 'invalid-credential':
        return FirebaseAuthException(
          code: e.code,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      case 'email-already-in-use':
        return FirebaseAuthException(
          code: e.code,
          message: 'البريد الإلكتروني مستخدم بالفعل',
        );
      case 'weak-password':
        return FirebaseAuthException(
          code: e.code,
          message: 'كلمة المرور ضعيفة',
        );
      case 'user-disabled':
        return FirebaseAuthException(
          code: e.code,
          message: 'تم تعطيل هذا الحساب',
        );
      default:
        return FirebaseAuthException(
          code: e.code,
          message: 'حدث خطأ غير متوقع',
        );
    }
  }
}
