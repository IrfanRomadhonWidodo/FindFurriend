// lib/controllers/admin/admin_orders_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrdersController extends GetxController {
  var isLoading = true.obs;
  var orders = [].obs;
  var filteredOrders = [].obs;
  var selectedStatus = 'All'.obs;

  final List<String> statusOptions = [
    'All',
    'pending-payment',
    'payment-uploaded',
    'payment-verified',
    'in-progress',
    'completed',
    'cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    ever(selectedStatus, (_) => filterOrders());
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);

      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      orders.value = ordersSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      filterOrders();
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterOrders() {
    if (selectedStatus.value == 'All') {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders
          .where((order) => order['status'] == selectedStatus.value)
          .toList();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': newStatus},
      );

      // Update local data
      final index = orders.indexWhere((order) => order['id'] == orderId);
      if (index != -1) {
        orders[index]['status'] = newStatus;
        filterOrders();
      }

      Get.snackbar(
        "Sukses",
        "Status pesanan berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memperbarui status pesanan: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
