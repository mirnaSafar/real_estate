// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/core/check_session_func.dart';
import 'package:real_estate/core/utils.dart';
import 'package:real_estate/features/real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRealEstateAddressesController extends GetxController {
  var properties = <Map<String, dynamic>>[
    {'name': 'الكل', 'id': 0},
  ].obs;

  RxBool isFetchLoading = true.obs;
  RxBool isAddLoading = false.obs;
  RxBool isInlineAddLoading = false.obs;
  RxMap<int, bool> isDeleteLoading = <int, bool>{}.obs;
  RxMap<int, bool> isUpdateLoading = <int, bool>{}.obs;
  final ClientRealEstateController _realEstateController = Get.find();
  String? getAddressOfAddressTag(String addressTag) => properties
      .firstWhereOrNull((e) => e["id"].toString() == addressTag)?["name"];
  @override
  void onInit() {
    initRealEstateAdresses();
    initFields();
    fetchRealEstateAdresses();
    supabase
        .from('real_estates_addresses')
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

  Future<void> fetchRealEstateAdresses({bool? showLoading = true}) async {
    if (showLoading == true) isFetchLoading.value = true;
    final List<Map<String, dynamic>> data = await supabase
        .from('real_estates_addresses')
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

  Future<void> fetchRealEstateByAddress({required int addressId}) async {
    await _realEstateController.fetchRealEstates();
    _realEstateController.properties.value = (addressId != 0)
        ? _realEstateController.properties.value
              .where((element) => element["address_tag"] == addressId)
              .toList()
        : _realEstateController.properties.value;
    _realEstateController.update();
  }

  final formKey = GlobalKey<FormState>();
  final addressNameController = TextEditingController();
  // final inlineAddController = TextEditingController();

  void initRealEstateAdresses([dynamic address]) {
    if (address != null) {
      addressNameController.text = address["name"];
    } else {
      addressNameController.text = "";
    }
  }

  Future<void> createRealEstateAddress() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Not logged in');
    }

    try {
      if (formKey.currentState!.validate()) {
        await checkSessionFunction(() async {
          isAddLoading.value = true;
          await supabase.from('real_estates_addresses').insert({
            // 'owner_id': user.id,
            "name": addressNameController.text,
          }).select();
          fetchRealEstateAdresses();
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
          messageText: Text("فشل إضافة العنوان"),
          overlayColor: Colors.white,
          backgroundColor: Colors.white,
        ),
      );
      isAddLoading.value = false;
    }
  }

  Future<String?> createRealEstateAddressInline() async {
    if (addressNameController.text.isEmpty) return null;
    return await checkSessionFunction<String?>(() async {
      isInlineAddLoading.value = true;
      try {
        final List<Map<String, dynamic>> data = await supabase
            .from('real_estates_addresses')
            .insert({"name": addressNameController.text})
            .select();
        await fetchRealEstateAdresses();
        addressNameController.clear();
        isInlineAddLoading.value = false;
        return data.first['id'].toString();
      } catch (e) {
        debugPrint('Inline add error: $e');
        isInlineAddLoading.value = false;
        Get.snackbar("خطأ", "فشل إضافة العنوان");
        return null;
      }
    });
  }

  Future<void> upateRealEstateAddress(
    String id, {
    required String title,
  }) async {
    final supabase = Supabase.instance.client;
    if (formKey.currentState!.validate()) {
      await checkSessionFunction(() async {
        isUpdateLoading[int.parse(id)] = true;
        properties.value = await supabase
            .from('real_estates_addresses')
            .update({'name': title})
            .eq('id', id)
            .select();
        await fetchRealEstateAdresses();
        isUpdateLoading[int.parse(id)] = false;

        Get.back();
      });
    }
  }

  Future<void> deleteRealEstateAddress(String id) async {
    final supabase = Supabase.instance.client;
    await checkSessionFunction(() async {
      isDeleteLoading[int.parse(id)] = true;
      try {
        await supabase
            .from('real_estates_addresses')
            .delete()
            .eq('id', id)
            .select();
        await fetchRealEstateAdresses(showLoading: false);
        isDeleteLoading[int.parse(id)] = false;
      } catch (e) {
        isDeleteLoading[int.parse(id)] = false;
      }
    });
  }

  @override
  void onClose() {
    addressNameController.dispose();

    initFields();
    super.onClose();
  }

  void initFields() {
    isAddLoading.value = false;
    isInlineAddLoading.value = false;
    addressNameController.text = '';
    isDeleteLoading.map((key, value) => MapEntry(key, false));
    isUpdateLoading.map((key, value) => MapEntry(key, false));
    isFetchLoading.value = false;
  }
}
