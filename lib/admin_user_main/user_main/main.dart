import 'package:flutter/material.dart';
import 'package:real_estate/admin_user_main/app.dart';
import '../../core/init_app.dart';

Future<void> main() async {
  await AppInitializer.init();
  runApp(RealEstateApp(isAdmin: false));
}
