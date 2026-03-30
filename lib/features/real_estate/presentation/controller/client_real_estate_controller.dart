import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/core/check_session_func.dart';
import 'package:real_estate/core/utils.dart';
import 'package:real_estate/features/login/presentation/controller/login_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRealEstateController extends GetxController {
  RxList<dynamic> properties = [].obs;
  RxBool isLogging = false.obs;
  RxBool isFetchLoading = true.obs;
  RxBool isAddLoading = false.obs;
  RxMap<int, bool> isDeleteLoading = <int, bool>{}.obs;
  RxMap<int, bool> isUpdateLoading = <int, bool>{}.obs;
  LoginController loginController = Get.find();
  @override
  void onInit() {
    try {
      checkSession();
      initRealEstate();
      initFields();
      fetchRealEstates();

      supabase
          .from('real_estates')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .listen((data) {
            properties.value = data;
          });
    } catch (e) {
      debugPrint("Supabase not initialized: $e");
    }
    super.onInit();
  }

  void checkSession() {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        loginController.isAdmin.value = true;
      }
    } catch (e) {
      debugPrint("Could not check session: $e");
    }
  }

  Future<void> fetchRealEstates({bool? showLoading = true}) async {
    try {
      if (showLoading == true) isFetchLoading.value = true;
      final data = await supabase
          .from('real_estates')
          .select()
          .order('created_at', ascending: false);
      properties.value = data;
      if (showLoading == true) isFetchLoading.value = false;
      properties.map((element) {
        isUpdateLoading.putIfAbsent(element["id"], () => false);
        isDeleteLoading.putIfAbsent(element["id"], () => false);
      });
      update();
    } catch (e) {
      debugPrint("Error fetching real estates: $e");
      isFetchLoading.value = false;
    }
  }

  // Removed redundant fetchRealEstatesTypes that was overwriting properties
  // The types are correctly handled in ClientRealEstateTypesController

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  RxnString typeController = RxnString(null);
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final roomsController = TextEditingController();
  final floorController = TextEditingController();
  final propertyController = TextEditingController();
  final areaController = TextEditingController();
  final descController = TextEditingController();
  RxList<XFile> selectedMedia = <XFile>[].obs;
  RxList<XFile> realEstateMedia = <XFile>[].obs;
  RxBool isPriceHidden = false.obs;
  RxBool isFilterVisible = false.obs;
  RxString selectedAddressFilter = "0".obs;
  RxString selectedTypeFilter = "0".obs;
  RxString selectedOfferFilter = "0".obs;
  RxString selectedCladingFilter = "0".obs;
  RxString currency = "\$".obs;
  RxnString cladingController = RxnString(null);
  RxnString offerController = RxnString(null);
  RxnString addressTagController = RxnString(null);

  // RxList<String> selectedTypeIds = <String>[].obs;

  List<dynamic> get filteredProperties {
    var results = properties;

    // Filter by Type (multi-select stored as list in DB)
    if (selectedTypeFilter.value != "0") {
      results = results
          .where((p) {
            return p['type'].toString() == selectedTypeFilter.value;
          })
          .toList()
          .obs;
    }

    // Filter by Offer
    if (selectedOfferFilter.value != "0") {
      results = results
          .where((p) {
            return p['offer_type'].toString() == selectedOfferFilter.value;
          })
          .toList()
          .obs;
    }

    // Filter by Address
    if (selectedAddressFilter.value.isNotEmpty &&
        selectedAddressFilter.value != "0") {
      results = results
          .where((p) {
            return p['address_tag'].toString() == selectedAddressFilter.value;
          })
          .toList()
          .obs;
    }

    // Filter by Clading
    if (selectedCladingFilter.value != "0") {
      results = results
          .where((p) {
            return p['clading'].toString() == selectedCladingFilter.value;
          })
          .toList()
          .obs;
    }

    return results;
  }

  // List<dynamic> get filteredProperties {
  //   if (selectedTypeFilter.isEmpty || selectedTypeFilter.contains("0")) {
  //     return properties;
  //   }
  //   return properties.where((p) {
  //     final propertyTypes = ((p['type'] as List?) ?? [])
  //         .map((e) => e.toString())
  //         .toList();

  //     return propertyTypes.contains(selectedTypeFilter.value);
  //   }).toList();
  // }

  void initRealEstate([dynamic realestate]) {
    if (realestate != null) {
      titleController.text = realestate["title"];
      priceController.text = realestate["price"].toString();
      locationController.text = realestate["location"];
      roomsController.text = realestate["roomNum"].toString();
      descController.text = realestate["description"];
      realEstateMedia.value = realestate["media"] != null
          ? (realestate["media"] as List<dynamic>).map((e) => XFile(e)).toList()
          : [];
      isPriceHidden.value = realestate["is_price_hidden"] ?? false;
      if (realestate["type"] != null) {
        typeController.value = realestate["type"].toString();
      } else {
        typeController.value = null;
      }
      if (realestate["clading"] != null) {
        cladingController.value = realestate["clading"].toString();
      } else {
        cladingController.value = null;
      }
      if (realestate["offer_type"] != null) {
        offerController.value = realestate["offer_type"].toString();
      } else {
        offerController.value = null;
      }
      if (realestate["address_tag"] != null) {
        addressTagController.value = realestate["address_tag"].toString();
      } else {
        addressTagController.value = null;
      }
      if (realestate["floor_number"] != null) {
        floorController.text = realestate["floor_number"].toString();
      } else {
        floorController.text = "";
      }
      if (realestate["property"] != null) {
        propertyController.text = realestate["property"].toString();
      } else {
        propertyController.text = "";
      }
      if (realestate["area"] != null) {
        areaController.text = realestate["area"].toString();
      } else {
        areaController.text = "";
      }
    } else {
      titleController.text = "";
      priceController.text = "";
      locationController.text = "";
      roomsController.text = "";
      floorController.text = "";
      propertyController.text = "";
      areaController.text = "";
      descController.text = "";
      realEstateMedia.value = [];
      isPriceHidden.value = false;
      typeController.value = null;
      cladingController.value = null;
      offerController.value = null;
      addressTagController.value = null;
      selectedMedia.clear();
    }
  }

  Future<List<String>> _uploadMedia() async {
    // Ensure administrator is authenticated before attempting storage upload.
    // Supabase Storage RLS policies evaluate auth.uid() — the session token
    // must be present or uploads will always receive 403 Unauthorized.
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('يجب تسجيل الدخول لرفع الصور');
    }

    List<String> imageUrls = [];
    final storage = Supabase.instance.client.storage;

    for (var file in selectedMedia) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      // NOTE: bucket name is case-sensitive in Supabase — must match exactly.
      final path = 'properties/$fileName';

      // Read file as bytes — works cross-platform (iOS, Android, Web).
      final bytes = await file.readAsBytes();

      // Upload using the authenticated session (auth.uid() will be non-null).
      await storage
          .from('images')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: false),
          );

      // Retrieve the public URL for the uploaded file.
      final String publicUrl = storage.from('images').getPublicUrl(path);
      imageUrls.add(publicUrl);
    }

    return imageUrls;
  }

  Future<void> createRealEstate() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Not logged in');
    }

    try {
      if (formKey.currentState!.validate()) {
        checkSessionFunction(() async {
          isAddLoading.value = true;

          // Upload new media and get public URLs
          List<String> newUrls = await _uploadMedia();

          await supabase.from('real_estates').insert({
            "title": titleController.text,
            "price": priceController.text,
            "location": locationController.text,
            "roomNum": roomsController.text,
            "description": descController.text,
            "type": typeController.value,
            "clading": cladingController.value,
            "offer_type": offerController.value,
            "address_tag": addressTagController.value,
            "floor_number": floorController.text,
            "property": propertyController.text,
            "area": areaController.text,
            "is_price_hidden": isPriceHidden.value,
            "currency": currency.value,
            "media": newUrls,
          }).select();

          selectedMedia.clear(); // Clear selections after successful upload
          fetchRealEstates();
          isAddLoading.value = false;
          Get.back();
        });
      } else {
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text('الحقول غير صالحة'),
            backgroundColor: Colors.orange.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
        isAddLoading.value = false;
      }
    } catch (e) {
      debugPrint('Error creating real estate: $e');
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 4),
          messageText: Text('خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
      isAddLoading.value = false;
    }
  }

  Future<void> updateRealEstate(
    String id, {
    required String title,
    required String description,
    required String price,
    required String roomNum,
    required String location,
    required String? type,
    required String? clading,
    required String? offerType,
    required String? addressTag,
    required String floor,
    required String propertyType,
    required String area,
  }) async {
    final supabase = Supabase.instance.client;
    try {
      if (formKey.currentState!.validate()) {
        checkSessionFunction(() async {
          isUpdateLoading[int.parse(id)] = true;

          // Keep existing URLs (realEstateMedia contains already uploaded URLs)
          List<String> combinedMedia = realEstateMedia
              .map((e) => e.path)
              .toList();

          // Upload newly selected media
          List<String> newUrls = await _uploadMedia();
          combinedMedia.addAll(newUrls);

          properties.value = await supabase
              .from('real_estates')
              .update({
                'title': title,
                "roomNum": roomNum,
                'description': description,
                'price': price,
                'location': location,
                "type": type,
                "clading": clading,
                "offer_type": offerType,
                "address_tag": addressTag,
                "floor_number": floor,
                "property": propertyType,
                "area": area,
                "is_price_hidden": isPriceHidden.value,
                "currency": currency.value,
                "media": combinedMedia,
              })
              .eq('id', int.parse(id))
              .select();

          selectedMedia.clear(); // Clear new selections after successful upload
          fetchRealEstates();
          isUpdateLoading[int.parse(id)] = false;

          Get.back();
        });
      } else {
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 2),
            messageText: const Text('الحقول غير صالحة'),
            backgroundColor: Colors.orange.shade700,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating real estate: $e');
      Get.showSnackbar(
        GetSnackBar(
          messageText: Text('خطأ: $e'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
      isUpdateLoading[int.parse(id)] = false;
    }
  }

  Future<void> deleteRealEstate(String id) async {
    checkSessionFunction(() async {
      final supabase = Supabase.instance.client;
      isDeleteLoading[int.parse(id)] = true;
      try {
        await supabase.from('real_estates').delete().eq('id', id).select();
        await fetchRealEstates(showLoading: false);
        Get.back();
        isDeleteLoading[int.parse(id)] = false;
      } catch (e) {
        isDeleteLoading[int.parse(id)] = false;
      }
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    roomsController.dispose();
    descController.dispose();
    priceController.dispose();
    locationController.dispose();
    propertyController.dispose();
    areaController.dispose();
    floorController.dispose();
    selectedMedia.clear();
    realEstateMedia.clear();
    typeController.value = null;
    cladingController.value = null;
    offerController.value = null;
    addressTagController.value = null;
    initFields();
    super.onClose();
  }

  void initFields() {
    isAddLoading.value = false;
    isDeleteLoading.map((key, value) => MapEntry(key, false));
    isUpdateLoading.map((key, value) => MapEntry(key, false));
    isFetchLoading.value = false;
    selectedMedia.clear();
    realEstateMedia.clear();
    typeController.value = null;
    cladingController.value = null;
    offerController.value = null;
    addressTagController.value = null;
    titleController.clear();
    priceController.clear();
    locationController.clear();
    roomsController.clear();
    descController.clear();
    floorController.clear();
    propertyController.clear();
    areaController.clear();
  }
}
