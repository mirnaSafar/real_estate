import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/main_page/presentation/view/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  RxBool isLogging = false.obs;
  RxBool isAdmin = false.obs;

  @override
  void onInit() {
    try {
      checkSession();
    } catch (e) {
      debugPrint("Supabase not initialized: $e");
    }
    super.onInit();
  }

  void checkSession() {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      isAdmin.value = true;
    }
  }

  final emailController = TextEditingController(text: 'realestate@salamis.com');
  final passwordController = TextEditingController(text: 'salamisrealestate');
  final formKey = GlobalKey<FormState>();

  Future<void> signInClient() async {
    try {
      final supabase = Supabase.instance.client;
      isLogging.value = true;
      await supabase.auth
          .signInWithPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((value) {
            isAdmin.value = true;
            Get.offAll(() => const MainPage());
            isLogging.value = false;
          });
    } catch (e) {
      isLogging.value = false;
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          messageText: Text('Login failed: $e'),
          title: "",
          titleText: Text(""),
        ),
      );
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    isAdmin.value = false;
    Get.offAll(() => const MainPage());
  }
}
