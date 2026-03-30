import 'dart:async';
import 'package:get/get.dart';
import 'package:real_estate/core/utils.dart';
import 'package:real_estate/features/login/presentation/view/login_screen.dart';

Future<T?> checkSessionFunction<T>(FutureOr<T> Function() callback) async {
  if (supabase.auth.currentSession != null) {
    return await callback();
  }

  Get.to(LoginScreen());
  return null;
}
