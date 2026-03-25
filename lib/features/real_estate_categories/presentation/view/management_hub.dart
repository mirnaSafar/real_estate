import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate/features/real_estate_categories/presentation/view/widgets/clading_types_management/clading_types_management.dart';
import 'package:real_estate/features/real_estate_categories/presentation/view/widgets/offer_types_management/offer_types_management.dart';
import 'package:real_estate/features/real_estate_categories/presentation/view/widgets/real_estates_addresses/real_estates_addresses.dart';
import 'package:real_estate/features/real_estate_categories/presentation/view/widgets/real_estates_types/real_estates_types.dart';

class ManagementHub extends StatelessWidget {
  const ManagementHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'مركز الإدارة',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildManagementCard(
              context,
              title: 'أنواع العقارات',
              icon: Icons.category_rounded,
              color: Colors.blue,
              onTap: () => Get.to(() => const RealEstatesTypes()),
            ),
            _buildManagementCard(
              context,
              title: 'أنواع العروض',
              icon: Icons.local_offer_rounded,
              color: Colors.orange,
              onTap: () => Get.to(() => const OfferTypesManagement()),
            ),
            _buildManagementCard(
              context,
              title: 'أنواع الإكساء',
              icon: Icons.format_paint_rounded,
              color: Colors.purple,
              onTap: () => Get.to(() => const CladingTypesManagement()),
            ),
            _buildManagementCard(
              context,
              title: 'العناوين',
              icon: Icons.location_on_rounded,
              color: Colors.green,
              onTap: () => Get.to(() => const RealEstatesAddresses()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
