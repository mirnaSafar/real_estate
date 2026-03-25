import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/real_estate/presentation/view/real_estate_details_page.dart';

/// Handles incoming deep links of the form:
///   `realestate://property?id=<id>`

class DeepLinkService {
  static final _appLinks = AppLinks();
  static StreamSubscription<Uri>? _sub;

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

  static void _handleLink(Uri uri) {
    if (uri.host == 'property') {
      final id = uri.queryParameters['id'];
      if (id == null) return;

      // Give GetX a moment if we're still navigating from splash
      Future.delayed(const Duration(milliseconds: 300), () {
        final controller = Get.find<ClientRealEstateController>();
        final property = controller.properties.firstWhereOrNull(
          (p) => p['id'].toString() == id,
        );
        if (property != null) {
          Get.to(() => RealEstateDetailsPage(property: property));
        }
      });
    }
  }

  static void dispose() {
    _sub?.cancel();
  }
}
