import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/view/widgets/real_estates/all_real_estates.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/view/widgets/management/management_hub.dart';
import 'package:real_estate/features/user_real_estate/user_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final ClientRealEstateController controller =
      Get.find<ClientRealEstateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: const Text(
          'عقاراتي',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          Transform.scale(scale: 1.2, child: Image.asset("assets/logo.jpeg")),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const UserView();
      case 1:
        return AllRealEstates();
      case 2:
        return const ManagementHub();
      default:
        return const Center(child: Text("Not Found"));
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'إدارة العقارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'الإدارة',
          ),
        ],
      ),
    );
  }
}
