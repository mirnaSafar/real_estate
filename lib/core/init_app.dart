import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/main_page/presentation/binding/main_binding.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    await Supabase.initialize(
      url: 'https://nhwsllaizbadcajeiyiq.supabase.co',
      anonKey: 'sb_publishable_ZcFPfijjSKQ83X0rS-Gawg_wHCrntAB',
    );
    
    MainBinding().dependencies();
  }
}
