import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/user_real_estate/user_view.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final ClientRealEstateController controller =
      Get.find<ClientRealEstateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: const Text(
          'سلاميس العقارية',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          Transform.scale(scale: 1.2, child: Image.asset("assets/logo.jpeg")),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return const UserView();
  }
}
