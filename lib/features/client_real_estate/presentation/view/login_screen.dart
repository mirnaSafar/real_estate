import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ClientRealEstateController controller = Get.put(ClientRealEstateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'الإيميل'),
            ),
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'كلمة السر'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.signInClient,
              child: const Text('تسجيل دخول'),
            ),
          ],
        ),
      ),
    );
  }
}
