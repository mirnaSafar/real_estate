import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_addresses_controller.dart';

class EditAddRealEstateAddress extends StatefulWidget {
  const EditAddRealEstateAddress({super.key, this.realestateType});
  final dynamic realestateType;
  @override
  State<EditAddRealEstateAddress> createState() =>
      _EditAddRealEstateAddressState();
}

class _EditAddRealEstateAddressState extends State<EditAddRealEstateAddress> {
  ClientRealEstateAddressesController controller = Get.put(
    ClientRealEstateAddressesController(),
  );
  @override
  void initState() {
    controller.initRealEstateAdresses(widget.realestateType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.realestateType == null ? "إضافة عنوان" : "تعديل العنوان",
        ),
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.category, size: 60, color: Colors.amber),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: controller.addressNameController,
                      decoration: InputDecoration(
                        labelText: 'العنوان',
                        prefixIcon: const Icon(
                          Icons.title,
                          color: Colors.amber,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.amber,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value!.isNotEmpty ? null : "الحقل مطلوب",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              Obx(() {
                final isAdding =
                    widget.realestateType == null &&
                    controller.isAddLoading.value;
                final isUpdating =
                    widget.realestateType != null &&
                    controller.isUpdateLoading.containsKey(
                      widget.realestateType['id'],
                    ) &&
                    controller.isUpdateLoading[widget.realestateType['id']] ==
                        true;

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
                                if (widget.realestateType == null) {
                                  await controller.createRealEstateAddress();
                                } else {
                                  await controller.upateRealEstateAddress(
                                    widget.realestateType["id"].toString(),
                                    title:
                                        controller.addressNameController.text,
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
                                widget.realestateType == null
                                    ? 'إضافة'
                                    : 'تعديل',
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
}
