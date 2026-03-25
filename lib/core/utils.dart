import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get supabase => Supabase.instance.client;

// Tag used for registering isAdmin state in GetX
const String kIsAdminTag = 'isAdmin';

// Global helper to access the current app mode
bool get isAppAdmin => Get.find<bool>(tag: kIsAdminTag);
