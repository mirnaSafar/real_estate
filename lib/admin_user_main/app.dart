// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/core/deep_link_service.dart';
import 'package:real_estate/core/utils.dart';
import 'package:real_estate/features/splash/presentation/view/splash_screen.dart';

class RealEstateApp extends StatefulWidget {
  const RealEstateApp({super.key, required this.isAdmin});
  final bool isAdmin;

  @override
  State<RealEstateApp> createState() => _RealEstateAppState();
}

class _RealEstateAppState extends State<RealEstateApp> {
  @override
  void initState() {
    super.initState();
    // Register isAdmin as a permanent dependency so it can be accessed anywhere
    Get.put(widget.isAdmin, tag: kIsAdminTag, permanent: true);
    DeepLinkService.init();
  }

  @override
  void dispose() {
    DeepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const SplashScreen(),
      locale: const Locale("ar"),
    );
  }
}
