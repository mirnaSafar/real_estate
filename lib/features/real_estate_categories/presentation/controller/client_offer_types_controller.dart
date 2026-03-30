// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/core/check_session_func.dart';
import 'package:real_estate/core/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:real_estate/features/real_estate/presentation/controller/client_real_estate_controller.dart';

class ClientOfferTypesController extends GetxController {
  var properties = <Map<String, dynamic>>[
    {"name": "الكل", "id": 0},
  ].obs;

  RxBool isFetchLoading = true.obs;
  RxBool isAddLoading = false.obs;
  RxBool isInlineAddLoading = false.obs;
  RxMap<int, bool> isDeleteLoading = <int, bool>{}.obs;
  RxMap<int, bool> isUpdateLoading = <int, bool>{}.obs;
  final ClientRealEstateController _realEstateController = Get.find();
  String? getOfferTypeName(String id) {
    return properties.firstWhereOrNull(
      (element) => element['id'].toString() == id,
    )?['name'];
  }

  @override
  void onInit() {
    initOfferTypes();
    initFields();
    fetchOfferTypes();
    supabase
        .from('real_estates_offer_types')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((data) {
          properties.value = [
            {'name': 'الكل', 'id': 0},
            ...data,
          ];
        });
    super.onInit();
  }

  Future<void> fetchOfferTypes({bool? showLoading = true}) async {
    if (showLoading == true) isFetchLoading.value = true;
    final List<Map<String, dynamic>> data = await supabase
        .from('real_estates_offer_types')
        .select()
        .order('created_at', ascending: false);
    properties.value = [
      {'name': 'الكل', 'id': 0},
      ...data,
    ];
    // properties.value.addAll(data);
    if (showLoading == true) isFetchLoading.value = false;
    properties.map((element) {
      isUpdateLoading.putIfAbsent(element["id"], () => false);
      isDeleteLoading.putIfAbsent(element["id"], () => false);
    });
    update();
  }

  Future<void> fetchRealEstateByOfferType({required int offerTypeId}) async {
    await _realEstateController.fetchRealEstates();
    _realEstateController.properties.value = (offerTypeId != 0)
        ? _realEstateController.properties.value
              .where((element) => element["offer_type"] == offerTypeId)
              .toList()
        : _realEstateController.properties.value;
    _realEstateController.update();
  }

  final formKey = GlobalKey<FormState>();
  final offerNameController = TextEditingController();
  // final inlineAddController = TextEditingController();

  void initOfferTypes([dynamic offerType]) {
    if (offerType != null) {
      offerNameController.text = offerType["name"];
    } else {
      offerNameController.text = "";
    }
  }

  Future<void> createOfferType() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Not logged in');
    }

    try {
      if (formKey.currentState!.validate()) {
        await checkSessionFunction(() async {
          isAddLoading.value = true;
          await supabase.from('real_estates_offer_types').insert({
            // 'owner_id': user.id,
            "name": offerNameController.text,
          }).select();
          await fetchOfferTypes();
          isAddLoading.value = false;
          Get.back();
        });
      } else {
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text('invalid fields'),
            overlayColor: Colors.white,
          ),
        );
        isAddLoading.value = false;
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          messageText: Text('حدثت مشكلة'),
          overlayColor: Colors.white,
          backgroundColor: Colors.white,
        ),
      );
      isAddLoading.value = false;
    }
  }

  Future<String?> createOfferTypeInline() async {
    if (offerNameController.text.isEmpty) return null;
    return await checkSessionFunction<String?>(() async {
      isInlineAddLoading.value = true;
      try {
        final List<Map<String, dynamic>> data = await supabase
            .from('real_estates_offer_types')
            .insert({"name": offerNameController.text})
            .select();
        await fetchOfferTypes();
        offerNameController.clear();
        isInlineAddLoading.value = false;
        return data.first['id'].toString();
      } catch (e) {
        debugPrint('Inline add error: $e');
        isInlineAddLoading.value = false;
        return null;
      }
    });
  }

  Future<void> updateofferType(String id, {required String title}) async {
    final supabase = Supabase.instance.client;
    if (formKey.currentState!.validate()) {
      await checkSessionFunction(() async {
        isUpdateLoading[int.parse(id)] = true;
        properties.value = await supabase
            .from('real_estates_offer_types')
            .update({'name': title})
            .eq('id', id)
            .select();
        await fetchOfferTypes();
        isUpdateLoading[int.parse(id)] = false;

        Get.back();
      });
    }
  }

  Future<void> deleteofferType(String id) async {
    final supabase = Supabase.instance.client;
    await checkSessionFunction(() async {
      isDeleteLoading[int.parse(id)] = true;
      try {
        await supabase
            .from('real_estates_offer_types')
            .delete()
            .eq('id', id)
            .select();
        await fetchOfferTypes(showLoading: false);
        isDeleteLoading[int.parse(id)] = false;
      } catch (e) {
        isDeleteLoading[int.parse(id)] = false;
      }
    });
  }

  @override
  void onClose() {
    offerNameController.dispose();

    initFields();
    super.onClose();
  }

  void initFields() {
    isAddLoading.value = false;
    isInlineAddLoading.value = false;
    offerNameController.text = '';
    isDeleteLoading.map((key, value) => MapEntry(key, false));
    isUpdateLoading.map((key, value) => MapEntry(key, false));
    isFetchLoading.value = false;
  }
}
