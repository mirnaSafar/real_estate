import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_addresses_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/view/widgets/real_estates_addresses/edit_add_real_estate_address.dart';

class RealEstatesAddresses extends StatefulWidget {
  const RealEstatesAddresses({super.key});

  @override
  State<RealEstatesAddresses> createState() => _RealEstatesAddressesState();
}

class _RealEstatesAddressesState extends State<RealEstatesAddresses> {
  final ClientRealEstateAddressesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العناوين'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "إدارة العناوين",
                      style: TextStyle(
                        fontSize: 18,
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
                          Get.to(() => const EditAddRealEstateAddress()),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: controller.properties.isEmpty
                      ? const Center(
                          child: Text(
                            "لا يوجد عناوين بعد",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.properties.length,
                          itemBuilder: (context, index) {
                            final property = controller.properties[index];
                            final dynamic id = property['id'];
                            if (id == 0) return const SizedBox.shrink();

                            return Obx(() {
                              final isDeleting =
                                  controller.isDeleteLoading[id] == true;

                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.amber.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  title: Text(
                                    property['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: isDeleting
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.red,
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () => Get.to(
                                                () => EditAddRealEstateAddress(
                                                  realestateType: property,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _showDeleteDialog(id),
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

  void _showDeleteDialog(dynamic id) {
    Get.dialog(
      AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذا العنوان؟"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteRealEstateAddress(id.toString());
              Get.back();
            },
            child: const Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
