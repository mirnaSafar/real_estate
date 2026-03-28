import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/core/utils.dart';
import 'package:real_estate/features/real_estate/presentation/view/edit_add_real_estate.dart';
import 'package:real_estate/features/real_estate/presentation/view/widgets/real_estates/auto_image_carousel.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_clading_types_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_offer_types_controller.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_addresses_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:real_estate/features/real_estate_categories/presentation/controller/client_real_estate_types_controller.dart';

class RealEstateDetailsPage extends StatelessWidget {
  const RealEstateDetailsPage({super.key, required this.property});
  final dynamic property;

  @override
  Widget build(BuildContext context) {
    ClientRealEstateAddressesController clientRealEstateAddressesController =
        Get.find();
    List<dynamic> media = property["media"] != null
        ? (property["media"] as List)
        : [];
    bool isPriceHidden = property['is_price_hidden'] ?? false;
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

    var addressTag = clientRealEstateAddressesController.getAddressOfAddressTag(
      property['address_tag'],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          property['title'] ?? 'تفاصيل العقار',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (formattedDate.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!, width: 0.5),
                ),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (media.isNotEmpty)
              AutoImageCarousel(media: media, height: 350)
            else
              Container(
                height: 350,
                color: Colors.grey[100],
                child: Image.asset("assets/logo.jpeg", fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.amber,
                            size: 22,
                          ),
                          tooltip: 'مشاركة العقار',
                          onPressed: () {
                            final id = property['id']?.toString() ?? '';
                            final title =
                                property['title'] ?? 'عقار في سلاميس العقارية';
                            final deepLink =
                                'https://salamisrealestate.com/property?id=$id';
                            SharePlus.instance.share(
                              ShareParams(
                                text:
                                    '🏠 $title\n\nاضغط على الرابط لعرض التفاصيل:\n$deepLink',
                                subject: title,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isAppAdmin)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.amber),
                          onPressed: () {
                            Get.to(EditAddRealEstate(realestate: property));
                          },
                        )
                      else if (isPriceHidden)
                        const Icon(
                          Icons.lock_outline,
                          color: Colors.amber,
                          size: 28,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      if (addressTag != "")
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber,
                          ),
                          child: Text(
                            addressTag,

                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property['location'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // const SizedBox(height: 30),
                  // const Text(
                  //   'نظرة عامة',
                  //   style: TextStyle(
                  //     fontSize: 22,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  _buildInfoGrid(property),
                  const SizedBox(height: 40),
                  if (property['description'] != "" &&
                      property['description'] != null) ...[
                    const Text(
                      'الوصف',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      property['description'] ?? 'لا يوجد وصف',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 24),
                  label: const Text(
                    'واتساب',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    await _sendToWhatsApp();
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.phone_outlined, size: 24),
                  label: const Text(
                    'اتصال',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final url = Uri.parse('tel:963966739593');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendToWhatsApp() async {
    final String title = property['title'] ?? '';
    final String id = property['id']?.toString() ?? '';
    final String area = property['area'] ?? '-';
    final String location = property['location'] ?? '';

    final String offerType = Get.find<ClientOfferTypesController>()
        .getOfferTypeName(property['offer_type']);
    final String propertyType = Get.find<ClientRealEstateTypesController>()
        .getRealEstateTypeName(property['type']);
    final String addressTag = Get.find<ClientRealEstateAddressesController>()
        .getAddressOfAddressTag(property['address_tag']);

    final String priceText = !property['is_price_hidden']
        ? '${property['price']} ل.س'
        : 'يتم الاستفسار عنه';

    final String deepLink = 'https://salamisrealestate.com/property?id=$id';

    final String message =
        '🏠 مرحباً، أود الاستفسار عن العقار التالي:\n\n'
        '📍 *العقار:* $title\n'
        '🏢 *النوع:* $propertyType - $offerType\n'
        '🗺️ *الموقع:* $addressTag - $location\n'
        '📐 *المساحة:* $area\n'
        '💰 *السعر:* $priceText\n\n'
        '🔗 *رابط العقار:*\n$deepLink';

    final text = Uri.encodeComponent(message);
    final url = Uri.parse('whatsapp://send?phone=963966739593&text=$text');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      final webUrl = Uri.parse('https://wa.me/963966739593?text=$text');
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      }
    }
  }

  Widget _buildInfoGrid(dynamic property) {
    ClientRealEstateTypesController clientRealEstateTypesController =
        Get.find();
    ClientOfferTypesController offerTypesController = Get.find();

    ClientRealEstateCladingTypesController realEstateCladingTypesController =
        Get.find();
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildInfoCard(
          Icons.local_offer_rounded,
          'العرض',
          offerTypesController.getOfferTypeName(property['offer_type']),
        ),
        _buildInfoCard(
          Icons.apartment_outlined,
          'النوع',
          clientRealEstateTypesController.getRealEstateTypeName(
            property['type'],
          ),
        ),
        _buildInfoCard(
          Icons.layers_outlined,
          'الطابق',
          '${property['floor_number'] ?? '-'}',
        ),
        _buildInfoCard(
          Icons.square_foot_outlined,
          'المساحة',
          '${property['area'] ?? '-'}',
        ),
        _buildInfoCard(
          Icons.add_chart_outlined,
          'الملكية',
          '${property['property'] ?? '-'}',
        ),

        _buildInfoCard(
          Icons.bed_outlined,
          'الغرف',
          '${property['roomNum'] ?? 0}',
        ),

        _buildInfoCard(
          Icons.format_paint_rounded,
          'الإكساء',
          realEstateCladingTypesController.getCladingTypeName(
            property['clading'],
          ),
        ),

        _buildInfoCard(
          Icons.payments_outlined,
          'السعر',
          !property['is_price_hidden']
              ? '${property['price']} ل.س'
              : "عند التواصل",
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      width: (Get.width - 64) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
