import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_clading_types_controller.dart';

class EditAddCladingType extends StatefulWidget {
  const EditAddCladingType({super.key, this.cladingType});
  final dynamic cladingType;

  @override
  State<EditAddCladingType> createState() => _EditAddCladingTypeState();
}

class _EditAddCladingTypeState extends State<EditAddCladingType> {
  final ClientRealEstateCladingTypesController controller = Get.find();

  @override
  void initState() {
    controller.initCladingTypes(widget.cladingType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cladingType == null ? "إضافة نوع كساء" : "تعديل نوع الكساء",
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
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.format_paint,
                      size: 60,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: controller.titleController,
                      decoration: InputDecoration(
                        labelText: 'نوع الكساء',
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
                    (widget.cladingType != null &&
                        controller.isUpdateLoading[widget.cladingType['id']] ==
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
                                if (widget.cladingType == null) {
                                  await controller.createCladingType();
                                } else {
                                  await controller.updateCladingType(
                                    widget.cladingType["id"].toString(),
                                    title: controller.titleController.text,
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
                                widget.cladingType == null ? 'إضافة' : 'تعديل',
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
