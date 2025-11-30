// lib/views/admin/admin_home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/admin/admin_main_controller.dart';
import 'dashboard/admin_dashboard_view.dart';
import 'orders/admin_orders_view.dart';
import 'services/admin_services_view.dart';
import 'profile/admin_profile_view.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminMainController adminController = Get.put(AdminMainController());

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: adminController.currentIndex.value,
            children: const [
              AdminDashboardView(),
              AdminOrdersView(),
              AdminServicesView(),
              AdminProfileView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  isSelected: adminController.currentIndex.value == 0,
                  onTap: () => adminController.changePage(0),
                ),
                _buildNavItem(
                  icon: Icons.receipt_long,
                  label: 'Pesanan',
                  isSelected: adminController.currentIndex.value == 1,
                  onTap: () => adminController.changePage(1),
                ),
                _buildNavItem(
                  icon: Icons.miscellaneous_services,
                  label: 'Layanan',
                  isSelected: adminController.currentIndex.value == 2,
                  onTap: () => adminController.changePage(2),
                ),
                _buildNavItem(
                  icon: Icons.admin_panel_settings,
                  label: 'Admin',
                  isSelected: adminController.currentIndex.value == 3,
                  onTap: () => adminController.changePage(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.orange : Colors.grey, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
