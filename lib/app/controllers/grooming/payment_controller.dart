import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentController extends GetxController {
  var selectedImage = Rx<File?>(null);
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

      // Ambil data order dari arguments
      final orderId = Get.arguments;
      if (orderId != null) {
        final snapshot = await FirebaseDatabase.instance
            .ref("orders/$orderId")
            .get();

        if (snapshot.exists) {
          orderData.value = snapshot.value as Map;

          // Siapkan data pembayaran
          paymentDetails.value = {
            'orderId': orderId,
            'serviceName': orderData['serviceName'] ?? 'Grooming Service',
            'price': orderData['price'] ?? 0,
            'date': orderData['date'] ?? '',
            'time': orderData['time'] ?? '',
            'paymentMethod': orderData['paymentMethod'] ?? 'Transfer Bank',
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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
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

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not login";

      final storageRef = FirebaseStorage.instance.ref().child(
        "payment_proof/$orderId.jpg",
      );

      await storageRef.putFile(selectedImage.value!);
      String downloadUrl = await storageRef.getDownloadURL();

      await FirebaseDatabase.instance.ref("orders/$orderId").update({
        "paymentProof": downloadUrl,
        "status": "pending-payment", // Diubah menjadi pending-payment
        "paymentDate": DateTime.now().toIso8601String(),
      });

      Get.snackbar(
        "Sukses 🎉",
        "Bukti pembayaran berhasil diupload! Status: Menunggu Verifikasi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 5),
      );

      // Kembali ke halaman sebelumnya
      Get.back();
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
