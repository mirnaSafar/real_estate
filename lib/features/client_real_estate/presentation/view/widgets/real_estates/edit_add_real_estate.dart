import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:real_estate/features/client_real_estate/presentation/controller/client_clading_types_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_offer_types_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_addresses_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_types_controller.dart';

class EditAddRealEstate extends StatefulWidget {
  const EditAddRealEstate({super.key, this.realestate});
  final dynamic realestate;
  @override
  State<EditAddRealEstate> createState() => _EditAddRealEstateState();
}

class _EditAddRealEstateState extends State<EditAddRealEstate> {
  ClientRealEstateController controller = Get.find();

  final clientOfferTypesController = Get.find<ClientOfferTypesController>();
  ClientRealEstateAddressesController clientRealEstateAddressesController =
      Get.find();
  final typesController = Get.find<ClientRealEstateTypesController>();
  final cladingTypesController =
      Get.find<ClientRealEstateCladingTypesController>();

  @override
  void initState() {
    controller.initRealEstate(widget.realestate);
    cladingTypesController.initFields();
    typesController.initFields();
    clientOfferTypesController.initFields();
    clientRealEstateAddressesController.initFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.realestate == null ? "إضافة عقار" : "تعديل عقار"),
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker Section
              Center(
                child: InkWell(
                  onTap: () async {
                    try {
                      final picker = ImagePicker();
                      var files = await picker.pickMultipleMedia();
                      for (var e in files) {
                        !controller.selectedMedia.contains(e)
                            ? controller.selectedMedia.add(e)
                            : null;
                      }
                    } catch (e) {
                      debugPrint('Image pick error: $e');
                    }
                  },
                  borderRadius: BorderRadius.circular(55),
                  child: Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Column(
                  children: [
                    if (controller.realEstateMedia.isNotEmpty ||
                        controller.selectedMedia.isNotEmpty)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount:
                            controller.realEstateMedia.length +
                            controller.selectedMedia.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < controller.realEstateMedia.length) {
                            var currentMedia =
                                controller.realEstateMedia[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: currentMedia.path,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorWidget: (context, error, stackTrace) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: InkWell(
                                    onTap: () {
                                      controller.realEstateMedia.remove(
                                        currentMedia,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            var currentMedia =
                                controller.selectedMedia[index -
                                    controller.realEstateMedia.length];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: kIsWeb
                                      ? CachedNetworkImage(
                                          imageUrl: currentMedia.path,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : Image.file(
                                          File(currentMedia.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                              ),
                                        ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedMedia.remove(
                                        currentMedia,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                  ],
                );
              }),
              // const SizedBox(height: 30),

              // Form Fields
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: const Text('العرض'),
                    ),
                    Obx(() {
                      return DropdownButton<String>(
                        isExpanded: true,
                        value: controller.offerController.value,
                        hint: Text("اختر من القائمة"),
                        items: [
                          ...clientOfferTypesController.properties
                              .where((e) {
                                return e["id"] != 0;
                              })
                              .map<DropdownMenuItem<String>>((element) {
                                return DropdownMenuItem<String>(
                                  value: element['id'].toString(),
                                  child: Text(element["name"]),
                                );
                              }),
                          DropdownMenuItem<String>(
                            enabled: false,
                            value: "add_offer",
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: clientOfferTypesController
                                        .offerNameController,
                                    decoration: const InputDecoration(
                                      hintText: "إضافة عرض جديد...",
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                clientOfferTypesController
                                        .isInlineAddLoading
                                        .value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          final newId =
                                              await clientOfferTypesController
                                                  .createOfferTypeInline();
                                          if (newId != null &&
                                              context.mounted) {
                                            Navigator.pop(context);
                                            controller.offerController.value =
                                                newId;
                                          }
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          controller.offerController.value = value;
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),

                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (controller.typeController.isNotEmpty)
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                      //   child: Wrap(
                      //     spacing: 8,
                      //     runSpacing: 4,
                      //     children: controller.typeController.map((id) {
                      //       final type = typesController.properties
                      //           .firstWhere(
                      //             (element) => element['id'].toString() == id,
                      //             orElse: () => {'name': ''},
                      //           );
                      //       return Chip(
                      //         label: Text(
                      //           type['name'],
                      //           style: const TextStyle(fontSize: 12),
                      //         ),
                      //         onDeleted: () =>
                      //             controller.typeController.remove(id),
                      //         deleteIcon: const Icon(Icons.close, size: 16),
                      //         materialTapTargetSize:
                      //             MaterialTapTargetSize.shrinkWrap,
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: const Text('نوع العقار'),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value:
                              (typesController.properties.any(
                                (p) =>
                                    p['id'].toString() ==
                                    controller.typeController.value,
                              ))
                              ? controller.typeController.value
                              : null,
                          hint: Text("اختر من القائمة"),

                          items: [
                            ...typesController.properties
                                .where((element) => element['id'] != 0)
                                .map<DropdownMenuItem<String>>((element) {
                                  return DropdownMenuItem<String>(
                                    value: element['id'].toString(),
                                    child: Text(element["name"]),
                                  );
                                }),
                            DropdownMenuItem<String>(
                              enabled: false,
                              value: "add_type",
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          typesController.inlineAddController,
                                      decoration: const InputDecoration(
                                        hintText: "إضافة نوع جديد...",
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  typesController.isInlineAddLoading.value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () async {
                                            final newId = await typesController
                                                .createRealEstateTypeInline();
                                            if (newId != null &&
                                                context.mounted) {
                                              Navigator.pop(context);
                                              controller.typeController.value =
                                                  newId;
                                            }
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            controller.typeController.value = value;
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Obx(() {
                  return Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: const Text('عنوان العقار'),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: controller.addressTagController.value,
                        hint: Text("اختر من القائمة"),

                        items: [
                          ...clientRealEstateAddressesController.properties
                              .skipWhile((p) => p["id"] == 0)
                              .map<DropdownMenuItem<String>>((element) {
                                return DropdownMenuItem<String>(
                                  value: element['id'].toString(),
                                  child: Text(element["name"]),
                                );
                              }),
                          DropdownMenuItem<String>(
                            enabled: false,
                            value: "add_address",
                            child: Obx(() {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          clientRealEstateAddressesController
                                              .addressNameController,
                                      decoration: const InputDecoration(
                                        hintText: "إضافة عنوان جديد...",
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  clientRealEstateAddressesController
                                          .isInlineAddLoading
                                          .value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () async {
                                            final newId =
                                                await clientRealEstateAddressesController
                                                    .createRealEstateAddressInline();
                                            if (newId != null &&
                                                context.mounted) {
                                              Navigator.pop(context);
                                              controller
                                                      .addressTagController
                                                      .value =
                                                  newId;
                                            }
                                          },
                                        ),
                                ],
                              );
                            }),
                          ),
                        ],
                        onChanged: (value) {
                          controller.addressTagController.value = value;
                        },
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.locationController,
                label: 'الموقع',
                icon: Icons.location_on,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.titleController,
                label: 'اسم العقار',
                icon: Icons.title,
              ),

              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.areaController,
                label: "المساحة",
                icon: Icons.area_chart,
                type: TextInputType.text,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.floorController,
                label: "رقم الطابق",
                icon: Icons.home,
                type: TextInputType.text,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.propertyController,
                label: "الملكية",
                icon: Icons.add_chart_outlined,
                type: TextInputType.text,
                isRequired: false,
              ),

              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.roomsController,
                label: 'عدد الغرف',
                icon: Icons.bed,
                type: TextInputType.text,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),

                child: Obx(() {
                  final cladingTypesController =
                      Get.find<ClientRealEstateCladingTypesController>();
                  return Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: const Text('الإكساء'),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("اختر من القائمة"),
                          value:
                              (cladingTypesController.properties.any(
                                (p) =>
                                    p['id'].toString() ==
                                    controller.cladingController.value,
                              ))
                              ? controller.cladingController.value
                              : null,
                          items: [
                            ...cladingTypesController.properties
                                .where((p) => p["id"] != 0)
                                .map<DropdownMenuItem<String>>((element) {
                                  return DropdownMenuItem<String>(
                                    value: element['id'].toString(),
                                    child: Text(element["name"]),
                                  );
                                }),
                            DropdownMenuItem<String>(
                              enabled: false,
                              value: "add_clading",
                              child: Obx(() {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: cladingTypesController
                                            .inlineAddController,
                                        decoration: const InputDecoration(
                                          hintText: "إضافة إكساء جديد...",
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    cladingTypesController
                                            .isInlineAddLoading
                                            .value
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () async {
                                              final newId =
                                                  await cladingTypesController
                                                      .createCladingTypeInline();
                                              if (newId != null &&
                                                  context.mounted) {
                                                Navigator.pop(context);
                                                controller
                                                        .cladingController
                                                        .value =
                                                    newId;
                                              }
                                            },
                                          ),
                                  ],
                                );
                              }),
                            ),
                          ],
                          onChanged: (value) {
                            controller.cladingController.value = value;
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.descController,
                label: 'الوصف',
                icon: Icons.description,
                type: TextInputType.text,
                maxLines: 3,
                isRequired: false,
              ),

              // Hide Price Toggle
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.priceController,
                label: 'السعر',
                icon: Icons.attach_money,
                type: TextInputType.number,
                isPrice: true,
              ),
              const SizedBox(height: 16),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.amber.withValues(alpha: 0.05),
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      'إخفاء السعر عن العملاء',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'سيظهر كسعر غير محدد أو القفل بدلاً من الرقم الفعلي',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: controller.isPriceHidden.value,
                    activeThumbColor: Colors.amber,
                    onChanged: (bool value) {
                      controller.isPriceHidden.value = value;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Action Buttons
              Obx(() {
                final isAdding = controller.isAddLoading.value;
                final isUpdating =
                    widget.realestate != null &&
                    controller.isUpdateLoading.containsKey(
                      widget.realestate['id'],
                    ) &&
                    controller.isUpdateLoading[widget.realestate['id']] == true;

                return Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: (isAdding || isUpdating)
                            ? null
                            : () async {
                                if (widget.realestate == null) {
                                  await controller.createRealEstate();
                                } else {
                                  await controller.updateRealEstate(
                                    widget.realestate["id"].toString(),
                                    title: controller.titleController.text,
                                    price: int.parse(
                                      controller.priceController.text,
                                    ),
                                    location:
                                        controller.locationController.text,
                                    roomNum: controller.roomsController.text,

                                    description: controller.descController.text,
                                    type: controller.typeController.value,
                                    clading: controller.cladingController.value,
                                    offerType: controller.offerController.value,
                                    addressTag:
                                        controller.addressTagController.value,
                                    floor: controller.floorController.text,
                                    propertyType:
                                        controller.propertyController.text,
                                    area: controller.areaController.text,
                                  );
                                }
                              },
                        child: (isAdding || isUpdating)
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.realestate == null ? 'إضافة' : 'تعديل',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool isPrice = false,
    bool isRequired = true,
  }) {
    ClientRealEstateController clientRealEstateController = Get.find();
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,

        prefixIcon: isPrice
            ? Obx(
                () => Container(
                  width: 80,
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: clientRealEstateController.currency.value,
                      items: ['\$', 'ل.س']
                          .map(
                            (currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          clientRealEstateController.currency.value = value;
                        }
                      },
                    ),
                  ),
                ),
              )
            : Icon(icon, color: Colors.amber),
        suffix: isPrice
            ? Obx(() {
                final isPriceHidden =
                    clientRealEstateController.isPriceHidden.value;
                return Icon(
                  isPriceHidden ? Icons.lock : Icons.lock_open_outlined,
                  color: Colors.amber,
                );
              })
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
      ),
      validator: (value) => isRequired
          ? isPrice && clientRealEstateController.isPriceHidden.value
                ? null
                : value!.isNotEmpty
                ? null
                : "الحقل مطلوب"
          : null,
    );
  }
}
