// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/core/check_session_func.dart';
import 'package:real_estate/core/utils.dart';
import 'package:real_estate/features/real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRealEstateCladingTypesController extends GetxController {
  var properties = <Map<String, dynamic>>[
    {"name": "الكل", "id": 0},
  ].obs;

  RxBool isFetchLoading = true.obs;
  RxBool isAddLoading = false.obs;
  RxBool isInlineAddLoading = false.obs;
  RxMap<int, bool> isDeleteLoading = <int, bool>{}.obs;
  RxMap<int, bool> isUpdateLoading = <int, bool>{}.obs;
  final ClientRealEstateController _realEstateController = Get.find();
  @override
  void onInit() {
    initCladingTypes();
    initFields();
    fetchCladingTypes();
    supabase
        .from('real_estate_clading_types')
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

  String? getCladingTypeName(String id) {
    return properties.firstWhereOrNull(
      (element) => element['id'].toString() == id,
    )?['name'];
  }

  Future<void> fetchCladingTypes() async {
    isFetchLoading.value = true;
    final List<Map<String, dynamic>> data = await supabase
        .from('real_estate_clading_types')
        .select()
        .order('created_at', ascending: false);
    properties.value = [
      {'name': 'الكل', 'id': 0},
      ...data,
    ];
    // properties.value.addAll(data);
    isFetchLoading.value = false;
    properties.map((element) {
      isUpdateLoading.putIfAbsent(element["id"], () => false);
      isDeleteLoading.putIfAbsent(element["id"], () => false);
    });
    update();
  }

  Future<void> fetchRealEstateByCladigType({required int cladingTypeId}) async {
    await _realEstateController.fetchRealEstates();
    _realEstateController.properties.value = (cladingTypeId != 0)
        ? _realEstateController.properties.value
              .where((element) => element["clading"] == cladingTypeId)
              .toList()
        : _realEstateController.properties.value;
    _realEstateController.update();
  }

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final inlineAddController = TextEditingController();

  void initCladingTypes([dynamic realestateType]) {
    if (realestateType != null) {
      titleController.text = realestateType["name"];
    } else {
      titleController.text = "";
    }
  }

  Future<void> createCladingType() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Not logged in');
    }

    try {
      if (formKey.currentState!.validate()) {
        await checkSessionFunction(() async {
          isAddLoading.value = true;
          await supabase.from('real_estate_clading_types').insert({
            // 'owner_id': user.id,
            "name": titleController.text,
          }).select();
          fetchCladingTypes();
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

  Future<String?> createCladingTypeInline() async {
    if (inlineAddController.text.isEmpty) return null;
    try {
      return await checkSessionFunction<String?>(() async {
        isInlineAddLoading.value = true;
        final List<Map<String, dynamic>> data = await supabase
            .from('real_estate_clading_types')
            .insert({"name": inlineAddController.text})
            .select();
        await fetchCladingTypes();
        inlineAddController.clear();
        isInlineAddLoading.value = false;
        return data.first['id'].toString();
      });
    } catch (e) {
      debugPrint('Inline add error: $e');
      isInlineAddLoading.value = false;
      Get.snackbar("خطأ", "فشل إضافة الإكساء");
      return null;
    }
  }

  Future<void> updateCladingType(String id, {required String title}) async {
    final supabase = Supabase.instance.client;
    if (formKey.currentState!.validate()) {
      await checkSessionFunction(() async {
        isUpdateLoading[int.parse(id)] = true;
        properties.value = await supabase
            .from('real_estate_clading_types')
            .update({'name': title})
            .eq('id', id)
            .select();
        await fetchCladingTypes();
        isUpdateLoading[int.parse(id)] = false;

        Get.back();
      });
    }
  }

  Future<void> deleteCladingType(String id) async {
    await checkSessionFunction(() async {
      final supabase = Supabase.instance.client;
      isDeleteLoading[int.parse(id)] = true;
      await supabase
          .from('real_estate_clading_types')
          .delete()
          .eq('id', id)
          .select();
      fetchCladingTypes();
      isDeleteLoading[int.parse(id)] = false;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    inlineAddController.dispose();

    initFields();
    super.onClose();
  }

  void initFields() {
    isAddLoading.value = false;
    isInlineAddLoading.value = false;

    isDeleteLoading.map((key, value) => MapEntry(key, false));
    isUpdateLoading.map((key, value) => MapEntry(key, false));
    isFetchLoading.value = false;
  }
}
