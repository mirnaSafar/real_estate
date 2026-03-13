import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_offer_types_controller.dart';

class EditAddOfferType extends StatefulWidget {
  const EditAddOfferType({super.key, this.offerType});
  final dynamic offerType;

  @override
  State<EditAddOfferType> createState() => _EditAddOfferTypeState();
}

class _EditAddOfferTypeState extends State<EditAddOfferType> {
  final ClientOfferTypesController controller = Get.find();

  @override
  void initState() {
    controller.initOfferTypes(widget.offerType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.offerType == null ? "إضافة نوع عرض" : "تعديل نوع العرض",
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
        elevation: 0,
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
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.local_offer,
                      size: 60,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: controller.offerNameController,
                      decoration: InputDecoration(
                        labelText: 'اسم العرض',
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
                final isLoading =
                    controller.isAddLoading.value ||
                    (widget.offerType != null &&
                        controller.isUpdateLoading[widget.offerType['id']] ==
                            true);

                return Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
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
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (widget.offerType == null) {
                                  await controller.createOfferType();
                                } else {
                                  await controller.updateofferType(
                                    widget.offerType["id"].toString(),
                                    title: controller.offerNameController.text,
                                  );
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                widget.offerType == null ? 'إضافة' : 'تعديل',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
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
