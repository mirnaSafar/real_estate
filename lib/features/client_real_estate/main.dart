import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/binding/main_binding.dart';
import 'package:real_estate/features/client_real_estate/presentation/view/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'presentation/controller/client_real_estate_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nhwsllaizbadcajeiyiq.supabase.co',
    anonKey: 'sb_publishable_ZcFPfijjSKQ83X0rS-Gawg_wHCrntAB',
  );
  MainBinding().dependencies();

  runApp(ClientRealEstateApp());
}

// ignore: must_be_immutable
class ClientRealEstateApp extends StatelessWidget {
  ClientRealEstateApp({super.key});
  ClientRealEstateController controller = Get.put(ClientRealEstateController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: SplashScreen(),
      locale: Locale("ar"),
    );
  }
}
