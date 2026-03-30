import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:real_estate/features/real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/real_estate/presentation/view/real_estate_details_page.dart';

/// Handles incoming deep links of the form:
///   `realestate://property?id=<id>`

class DeepLinkService {
  static final _appLinks = AppLinks();
  static StreamSubscription<Uri>? _sub;
  static bool isHandlingLink = false;

  /// Call once in [RealEstateApp.initState] or equivalent.
  static void init() {
    // Handle links received while the app is already running
    _sub = _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri);
    });

    // Handle the initial link (app opened via a link while closed)
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleLink(uri);
    });
  }

  static void _handleLink(Uri uri) async {
    // Handle both realestate://property and https://salamisrealestate.com/property
    final isPropertyLink =
        (uri.host == 'property' || uri.host == 'salamisrealestate.com');

    if (isPropertyLink) {
      final id = uri.queryParameters['id'];
      if (id == null) return;

      // Give GetX a moment if we're still navigating from splash
      await Future.delayed(const Duration(milliseconds: 500));

      final controller = Get.find<ClientRealEstateController>();

      // 1. Try to find in already loaded properties
      var property = controller.properties.firstWhereOrNull(
        (p) => p['id'].toString() == id,
      );

      // 2. If not found (maybe not loaded yet), fetch it directly from Supabase
      if (property == null) {
        try {
          final data = await Supabase.instance.client
              .from('real_estates')
              .select()
              .eq('id', int.parse(id))
              .maybeSingle();
          property = data;
        } catch (e) {
          debugPrint("Error fetching property via deep link: $e");
        }
      }

      if (property != null) {
        isHandlingLink = true;
        Get.offAll(() => RealEstateDetailsPage(property: property!));
      }
    }
  }

  static void dispose() {
    _sub?.cancel();
  }
}
