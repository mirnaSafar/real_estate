import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/real_estate/presentation/controller/client_real_estate_controller.dart';
import 'package:real_estate/features/real_estate/presentation/view/real_estate_details_page.dart';

import 'package:real_estate/features/real_estate/presentation/view/widgets/real_estates/auto_image_carousel.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_clading_types_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_offer_types_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_addresses_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_types_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ClientRealEstateController controller =
        Get.find<ClientRealEstateController>();
    final ClientRealEstateTypesController typesController = Get.find();
    final ClientOfferTypesController offerTypesController = Get.find();
    final ClientRealEstateAddressesController addressesController = Get.find();
    final ClientRealEstateCladingTypesController cladingTypesController =
        Get.find();

    return Container(
      color: Colors.grey[50], // sleek background
      child: Column(
        children: [
          // Filtering Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterWidget(
                            typesController,
                            controller.selectedTypeFilter,
                            "التصنيف",
                          ),
                          _buildFilterWidget(
                            offerTypesController,
                            controller.selectedOfferFilter,
                            "نوع العرض",
                          ),
                          _buildFilterWidget(
                            addressesController,
                            controller.selectedAddressFilter,
                            "المنطقة",
                          ),
                          _buildFilterWidget(
                            cladingTypesController,
                            controller.selectedCladingFilter,
                            "الإكساء",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  controller.selectedTypeFilter.value = "0";
                                  controller.selectedOfferFilter.value = "0";
                                  controller.selectedAddressFilter.value = "0";
                                  controller.selectedCladingFilter.value = "0";
                                  Get.back();
                                },
                                child: const Text("مسح"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("تطبيق"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "فلترة العقارات",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  Obx(
                    () => Icon(
                      controller.isFilterVisible.value
                          ? Icons.filter_alt
                          : Icons.filter_alt_outlined,
                      color: controller.isFilterVisible.value
                          ? Colors.amber[800]
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Filters
          // Obx(() {
          //   if (!controller.isFilterVisible.value) {
          //     return const SizedBox.shrink();
          //   }

          // }),
          Expanded(
            child: Obx(() {
              if (controller.isFetchLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final properties = controller.filteredProperties;

              if (properties.isEmpty) {
                return const Center(
                  child: Text(
                    "لا يوجد عقارات تطابق بحثك",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  final bool isPriceHidden =
                      property['is_price_hidden'] ?? false;
                  final String createdAt = property['created_at'] ?? '';
                  String formattedDate = '';
                  if (createdAt.isNotEmpty) {
                    try {
                      final date = DateTime.parse(createdAt);
                      formattedDate = '${date.day}/${date.month}/${date.year}';
                    } catch (e) {
                      formattedDate = '';
                    }
                  }

                  return Card(
                    elevation: 8,
                    shadowColor: Colors.black.withValues(alpha: 0.1),
                    margin: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => Get.to(
                        () => RealEstateDetailsPage(property: property),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 240,
                            child: Stack(
                              children: [
                                AutoImageCarousel(
                                  media: property["media"] ?? [],
                                  height: 240,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                if (formattedDate.isNotEmpty)
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        property['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                    if (isPriceHidden)
                                      const Icon(
                                        Icons.lock_outline,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (property['address_tag'] !=
                                                        null &&
                                                    property['address_tag']
                                                        .toString()
                                                        .isNotEmpty)
                                                  Text(
                                                    addressesController
                                                        .getAddressOfAddressTag(
                                                          property['address_tag'],
                                                        ),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                // if (property['location'] !=
                                                //         null &&
                                                //     property['location']
                                                //         .isNotEmpty)
                                                //   Text(
                                                //     property['location'] ?? '',
                                                //     style: TextStyle(
                                                //       fontSize: 15,
                                                //       color: Colors.grey[600],
                                                //       fontWeight:
                                                //           FontWeight.w500,
                                                //     ),
                                                //   ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        child: Text(
                                          offerTypesController.getOfferTypeName(
                                            property['offer_type'],
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'السعر',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        ),
                                        isPriceHidden
                                            ? const Text(
                                                'تواصل للتفاصيل',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                '${property['price']} ل.س',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.bed_outlined,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${property['roomNum'] ?? 0} غرف',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF25D366,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          elevation: 0,
                                        ),
                                        icon: const Icon(
                                          Icons.chat_bubble_outline,
                                          size: 20,
                                        ),
                                        label: const Text(
                                          'واتساب',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final text = Uri.encodeComponent(
                                            'مرحباً، أود الاستفسار عن عقار ${property['title']}',
                                          );
                                          final url = Uri.parse(
                                            'whatsapp://send?phone=963966739593&text=$text',
                                          );
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            final webUrl = Uri.parse(
                                              'https://wa.me/963966739593?text=$text',
                                            );
                                            if (await canLaunchUrl(webUrl)) {
                                              await launchUrl(webUrl);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          elevation: 0,
                                        ),
                                        icon: const Icon(
                                          Icons.phone_outlined,
                                          size: 20,
                                        ),
                                        label: const Text(
                                          'اتصال',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final url = Uri.parse(
                                            'tel:963966739593',
                                          );
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }

  Widget _buildFilterWidget(
    dynamic filterController,
    RxString filterValue,
    String filterTitle,
  ) {
    if ((filterController.properties as Iterable).isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filterTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.start,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              children: (filterController.properties as Iterable).map<Widget>((
                type,
              ) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Obx(() {
                    final isSelected =
                        filterValue.value == type['id'].toString();
                    return ChoiceChip(
                      label: Text(
                        type['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black87 : Colors.grey[700],
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.amber,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.amber : Colors.grey[300]!,
                        ),
                      ),
                      showCheckmark: false,
                      onSelected: (selected) {
                        if (selected) {
                          filterValue.value = type['id'].toString();
                        } else {
                          filterValue.value = "0";
                        }
                      },
                    );
                  }),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
