//grooming_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroomingController extends GetxController {
  var selectedPet = 'Kucing'.obs;
  var selectedDate = DateTime.now().obs;
  var selectedPackage = 'Basic'.obs;
  var promoCode = ''.obs;

  // Harga berdasarkan jenis hewan dan paket
  Map<String, Map<String, int>> priceTable = {
    "Kucing": {"Basic": 75000, "Komplit": 120000, "Spesial": 180000},
    "Anjing": {"Basic": 100000, "Komplit": 150000, "Spesial": 220000},
  };

  // Detail paket berdasarkan jenis hewan
  Map<String, Map<String, String>> packageDetails = {
    "Kucing": {
      "Basic": "Mandi, potong kuku, membersihkan telinga",
      "Komplit": "Basic + potong rambut, parfum khusus",
      "Spesial": "Komplit + treatment khusus, vitamin, perawatan bulu",
    },
    "Anjing": {
      "Basic": "Mandi, potong kuku, membersihkan telinga",
      "Komplit": "Basic + potong rambut, parfum khusus",
      "Spesial": "Komplit + treatment khusus, vitamin, perawatan bulu",
    },
  };

  // Kode promo
  Map<String, double> promoCodes = {
    "FINDFURRIEND99": 0.10,
    "PETCARE20": 0.15,
    "GROOMING15": 0.20,
  };

  int get originalPrice {
    return priceTable[selectedPet.value]?[selectedPackage.value] ?? 0;
  }

  int get totalPrice {
    double price = originalPrice.toDouble();
    if (promoCodes.containsKey(promoCode.value.toUpperCase())) {
      price *= (1 - promoCodes[promoCode.value.toUpperCase()]!);
    }
    return price.round();
  }

  double get discountPercentage {
    if (promoCodes.containsKey(promoCode.value.toUpperCase())) {
      return promoCodes[promoCode.value.toUpperCase()]!;
    }
    return 0.0;
  }

  int get discountAmount {
    return (originalPrice * discountPercentage).round();
  }

  bool get isPromoValid {
    return promoCodes.containsKey(promoCode.value.toUpperCase());
  }

  String formatPrice(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  void selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // ================================
  // 🔥 SAVE ORDER FIREBASE DISINI
  // ================================
  Future<void> saveGroomingOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar(
        "Gagal",
        "Login dulu dong 😅",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final orderRef = FirebaseFirestore.instance.collection("orders").doc();

    await orderRef.set({
      "orderId": orderRef.id,
      "userId": user.uid,
      "serviceType": "grooming",
      "pet": selectedPet.value,
      "package": selectedPackage.value,
      "originalPrice": originalPrice,
      "discount": discountAmount,
      "totalPrice": totalPrice,
      "promoCode": promoCode.value,
      "date": selectedDate.value.toIso8601String(),
      "status": "pending-payment",
      "createdAt": DateTime.now().toIso8601String(),
    });

    Get.snackbar(
      "Sukses 🎉",
      "Pesanan berhasil dibuat!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.toNamed('/upload-payment', arguments: orderRef.id);
  }
}
