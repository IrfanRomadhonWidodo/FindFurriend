// lib/controllers/admin/admin_dashboard_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardController extends GetxController {
  var isLoading = true.obs;
  var stats = {
    'totalOrders': 0,
    'newOrders': 0,
    'revenue': 0,
    'customers': 0,
  }.obs;

  var recentOrders = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);

      // Fetch orders count
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .get();
      stats['totalOrders'] = ordersSnapshot.size;

      // Fetch new orders (status: pending-payment or payment-uploaded)
      final newOrdersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', whereIn: ['pending-payment', 'payment-uploaded'])
          .get();
      stats['newOrders'] = newOrdersSnapshot.size;

      // Fetch revenue
      int totalRevenue = 0;
      for (var doc in ordersSnapshot.docs) {
        if (doc['status'] == 'completed') {
          final data = doc.data();
          totalRevenue += (data['totalPrice'] ?? 0) as int;
        }
      }
      stats['revenue'] = totalRevenue;

      // Fetch unique customers
      Set<String> customers = {};
      for (var doc in ordersSnapshot.docs) {
        customers.add(doc['userId']);
      }
      stats['customers'] = customers.length;

      // Fetch recent orders
      // Realtime recent orders
      FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots()
          .listen((snapshot) {
            recentOrders.value = snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList();
            recentOrders.refresh();
          });
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading(false);
    }
  }
}
