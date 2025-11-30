// lib/controllers/admin/admin_payment_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class AdminPaymentController extends GetxController {
  var isLoading = true.obs;
  var payments = [].obs;
  var selectedPayment = {}.obs;

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Called when the GetxController is initialized.
  /// Fetches all payments from Firestore database.
  /*******  9e09e73f-9d66-4e87-aef0-03615bb35e62  *******/
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      isLoading(true);

      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('status', isEqualTo: 'pending-verification')
          .orderBy('paymentDate', descending: true)
          .get();

      payments.value = paymentsSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching payments: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPaymentDetails(String paymentId) async {
    try {
      isLoading(true);

      final paymentDoc = await FirebaseFirestore.instance
          .collection('payments')
          .doc(paymentId)
          .get();

      if (paymentDoc.exists) {
        selectedPayment.value = paymentDoc.data()!;
        selectedPayment['id'] = paymentDoc.id;

        // Fetch order details
        final orderDoc = await FirebaseFirestore.instance
            .collection('orders')
            .doc(selectedPayment['orderId'])
            .get();

        if (orderDoc.exists) {
          selectedPayment['orderDetails'] = orderDoc.data();
        }
      }
    } catch (e) {
      print('Error fetching payment details: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> approvePayment(String paymentId, String orderId) async {
    try {
      // Update payment status
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(paymentId)
          .update({'status': 'verified'});

      // Update order status
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'payment-verified'},
      );

      // Update local data
      final index = payments.indexWhere(
        (payment) => payment['id'] == paymentId,
      );
      if (index != -1) {
        payments.removeAt(index);
      }

      Get.back(); // Close detail view
      Get.snackbar(
        "Sukses",
        "Pembayaran telah disetujui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menyetujui pembayaran: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> rejectPayment(
    String paymentId,
    String orderId,
    String reason,
  ) async {
    try {
      // Update payment status
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(paymentId)
          .update({
            'status': 'rejected',
            'rejectionReason': reason,
            'rejectionDate': DateTime.now().toIso8601String(),
          });

      // Update order status
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'payment-rejected'},
      );

      // Update local data
      final index = payments.indexWhere(
        (payment) => payment['id'] == paymentId,
      );
      if (index != -1) {
        payments.removeAt(index);
      }

      Get.back(); // Close detail view
      Get.snackbar(
        "Sukses",
        "Pembayaran telah ditolak",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menolak pembayaran: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
