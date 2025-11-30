// lib/controllers/training/training_payment_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class TrainingPaymentController extends GetxController {
  var selectedImage = Rx<XFile?>(null);
  var isLoading = false.obs;
  var fileSelected = false.obs;

  // Data pembayaran
  var orderData = {}.obs;
  var paymentDetails = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not login";

      // Perbaiki penanganan arguments
      final dynamic args = Get.arguments;
      final String orderId;

      if (args is String) {
        orderId = args;
      } else if (args is Map) {
        // Jika arguments adalah Map, coba ambil orderId dari Map
        orderId = args['orderId']?.toString() ?? '';
      } else {
        // Jika arguments bukan String atau Map, konversi ke string
        orderId = args?.toString() ?? '';
      }

      if (orderId.isNotEmpty && orderId != "null") {
        final doc = await FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .get();

        if (doc.exists) {
          orderData.value = doc.data()!;

          // Siapkan data pembayaran untuk training
          paymentDetails.value = {
            'orderId': orderId,
            'serviceName':
                "Training ${orderData['pet']} - ${orderData['package']}",
            'price': orderData['totalPrice'] ?? 0,
            'date': orderData['date']?.toString().split('T').first ?? '',
            'time': '', // kamu belum punya jam kan?
            'duration': orderData['package'] ?? '', // Menampilkan durasi paket
            'paymentMethod': 'Transfer Bank',
            'accountNumber': '1234-5678-9012',
            'accountName': 'FindFurriend',
            'bankName': 'Bank Central Asia',
          };
        }
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  Future<void> pickImage() async {
    // 🔥 Permission hanya di Android/iOS (bukan Web)
    if (!kIsWeb) {
      var status = await Permission.storage.request();

      if (!status.isGranted) {
        Get.snackbar(
          "Izin Ditolak",
          "Izin akses penyimpanan diperlukan untuk memilih gambar",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFile != null) {
      selectedImage.value = pickedFile;
      fileSelected.value = true;
    } else {
      Get.snackbar(
        "Ops!",
        "Tidak ada gambar yang dipilih",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[900],
      );
    }
  }

  Future<void> uploadPaymentProof(String orderId) async {
    if (selectedImage.value == null) {
      Get.snackbar(
        "Error",
        "Upload bukti pembayaran dulu 😅",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    isLoading.value = true;
    // 🔥 Simpan gambar sebagai Base64 ke Firestore
    final bytes = await selectedImage.value!.readAsBytes();
    String base64Image = base64Encode(bytes);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not login";

      await FirebaseFirestore.instance.collection("payments").doc(orderId).set({
        "orderId": orderId,
        "userId": user.uid,
        "paymentProof": base64Image,
        "paymentDate": DateTime.now().toIso8601String(),
        "status": "pending-verification",
      });

      await FirebaseFirestore.instance.collection("orders").doc(orderId).update(
        {"status": "payment-uploaded"},
      );

      Get.snackbar(
        "Sukses 🎉",
        "Bukti pembayaran berhasil diupload! Status: Menunggu Verifikasi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 5),
      );

      //  🔥 Redirect ke Home
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
