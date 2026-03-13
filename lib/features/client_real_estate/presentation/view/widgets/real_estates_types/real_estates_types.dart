import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_types_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/view/widgets/real_estates_types/edit_add_real_estate_type.dart';

class RealEstatesTypes extends StatefulWidget {
  const RealEstatesTypes({super.key});

  @override
  State<RealEstatesTypes> createState() => _RealEstatesTypesState();
}

class _RealEstatesTypesState extends State<RealEstatesTypes> {
  final ClientRealEstateTypesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الأنواع '),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isFetchLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        return Container(
          color: Colors.grey[50],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "إدارة الأنواع",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.add, color: Colors.black87),
                      label: const Text(
                        'إضافة',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () =>
                          Get.to(() => const EditAddRealEstateType()),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Types List
                Expanded(
                  child: controller.properties.isEmpty
                      ? const Center(
                          child: Text(
                            "لا يوجد أصناف عقارات بعد",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.properties.length,
                          itemBuilder: (context, index) {
                            final property = controller.properties[index];
                            final dynamic id = property['id'];

                            // Skip the "الكل" (All) placeholder item
                            if (id == 0) return const SizedBox.shrink();

                            return Obx(() {
                              final isDeleting =
                                  controller.isDeleteLoading[id] == true;

                              return Card(
                                elevation: 2,
                                shadowColor: Colors.black12,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon badge
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withValues(
                                            alpha: 0.15,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.category,
                                          color: Colors.amber,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Name
                                      Expanded(
                                        child: Text(
                                          property['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),

                                      // Actions
                                      if (isDeleting)
                                        const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.red,
                                          ),
                                        )
                                      else
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () => Get.to(
                                                () => EditAddRealEstateType(
                                                  realestateType: property,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () => Get.dialog(
                                                Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          20,
                                                        ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .warning_amber_rounded,
                                                          color: Colors.red,
                                                          size: 50,
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        const Text(
                                                          "تأكيد الحذف",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        const Text(
                                                          "متاكد من حذف نوع العقار؟",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 24,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Get.back(),
                                                              child: const Text(
                                                                "إلغاء",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                controller
                                                                    .deleteRealEstateType(
                                                                      id.toString(),
                                                                    );
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                "حذف",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
