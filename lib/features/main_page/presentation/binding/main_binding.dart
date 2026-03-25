import 'package:get/get.dart';
import 'package:real_estate/features/login/presentation/controller/login_controller.dart';
import 'package:real_estate/features/real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_clading_types_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_offer_types_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_addresses_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_types_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(ClientRealEstateController());
    Get.put(ClientRealEstateTypesController());
    Get.put(ClientRealEstateAddressesController());
    Get.put(ClientRealEstateCladingTypesController());
    Get.put(ClientOfferTypesController());
  }
}
