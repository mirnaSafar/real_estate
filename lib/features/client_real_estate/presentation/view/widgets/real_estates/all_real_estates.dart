import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_addresses_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/client_real_estate/presentation/view/widgets/real_estates/edit_add_real_estate.dart';

class AllRealEstates extends StatefulWidget {
  const AllRealEstates({super.key});

  @override
  State<AllRealEstates> createState() => _AllRealEstatesState();
}

class _AllRealEstatesState extends State<AllRealEstates> {
  ClientRealEstateController controller = Get.find();
  ClientRealEstateAddressesController clientRealEstateAddressesController =
      Get.find();

  @override
  Widget build(BuildContext context) {
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
                  "إدارة العقارات",
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
                  onPressed: () => Get.to(() => const EditAddRealEstate()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isFetchLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                }
                if (controller.properties.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا يوجد عقارات بعد",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.properties.length,
                  itemBuilder: (context, index) {
                    final property = controller.properties[index];
                    return Card(
                      elevation: 3,
                      shadowColor: Colors.black12,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Get.to(
                          () => EditAddRealEstate(realestate: property),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            if (property["media"] != null &&
                                (property["media"] as List).isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: property["media"][0],
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    width: 130,
                                    height: 130,
                                    color: Colors.grey[200],
                                    child: Image.asset(
                                      "assets/logo.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            if (property["media"] == null ||
                                (property["media"] as List).isEmpty)
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/logo.jpeg",
                                  fit: BoxFit.cover,
                                ),
                              ),

                            // Details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    property['is_price_hidden'] ?? false
                                        ? Text(
                                            'السعر غير معلن عنه',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            '${property['price']} ${property['currency']}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    const SizedBox(height: 8),
                                    Card(
                                      elevation: 0,
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    clientRealEstateAddressesController
                                                            .properties
                                                            .firstWhereOrNull(
                                                              (e) =>
                                                                  e["id"]
                                                                      .toString() ==
                                                                  property['address_tag'],
                                                            )?["name"] ??
                                                        '',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              property['location'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Edit/Delete actions
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => Get.to(
                                      () => EditAddRealEstate(
                                        realestate: property,
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    final isDeleting =
                                        controller
                                            .isDeleteLoading[property['id']] ==
                                        true;
                                    return isDeleting
                                        ? const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => Get.dialog(
                                              Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    20.0,
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
                                                      const SizedBox(height: 8),
                                                      const Text(
                                                        "متاكد من حذف العقار؟",
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
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                            onPressed: () {
                                                              controller.deleteRealEstate(
                                                                property['id']
                                                                    .toString(),
                                                              );
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
                                          );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
