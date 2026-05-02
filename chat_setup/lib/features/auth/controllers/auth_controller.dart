// ignore_for_file: unnecessary_null_comparison

import 'package:chat_setup/core/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;
  RxBool loginSuccess = false.obs;

  // للـ OTP
  RxString verificationId = ''.obs;

  @override
  void onInit() {
    user.bindStream(_service.authStateChanges());
    ever(user, (u) {
      if (u != null) {
        NotificationService.instance.initAndSaveToken();
      }
    });
    super.onInit();
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _service.login(email, password);
      return user != null;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('خطأ', e.message ?? 'فشل تسجيل الدخول');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(
    String email,
    String password,
    Map<String, dynamic> data,
  ) async {
    try {
      isLoading.value = true;

      await _service.register(email: email, password: password, userData: data);

      Get.snackbar('تم', 'تم إنشاء الحساب بنجاح');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar('خطأ', 'البريد الإلكتروني مستخدم بالفعل');
      } else {
        Get.snackbar('خطأ', e.message ?? 'حدث خطأ');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> registerWithPhone(
    String phone,
    String password,
    Map<String, dynamic> data,
  ) async {
    try {
      isLoading.value = true;

      // مؤقت (إلى أن تربط OTP حقيقي)
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 1) إرسال كود OTP للهاتف
  Future<void> sendPhoneOtp(String phone) async {
    try {
      isLoading.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: phone, // لازم يكون بصيغة +20...
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android أحياناً بيعمل auto-verify
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('خطأ', e.message ?? e.toString());
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          Get.snackbar('تم', 'تم إرسال كود التفعيل');
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 2) تأكيد OTP + إنشاء حساب + حفظ بياناتك
  Future<void> confirmPhoneOtpAndCreateUser({
    required String smsCode,
    required Map<String, dynamic> data,
  }) async {
    try {
      isLoading.value = true;

      if (verificationId.value.isEmpty) {
        Get.snackbar('خطأ', 'أرسل كود التفعيل أولاً');
        return;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);

      // await _service.saveUserData(userCred.user!.uid, data);

      Get.snackbar('تم', 'تم إنشاء الحساب بنجاح');
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('خطأ', e.message ?? e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
  }
}
