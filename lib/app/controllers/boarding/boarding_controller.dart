// lib/controllers/boarding/boarding_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardingController extends GetxController {
  // Observables (State Management)
  final selectedPet = 'Kucing'.obs;
  final selectedDate = DateTime.now().obs;
  final selectedPackage = 'Paket 1 Hari'.obs;
  final promoCode = ''.obs;

  // Data Statis untuk View
  final pets = ["Kucing", "Anjing"];
  final packageNames = [
    "Paket 1 Hari",
    "Paket 3 Hari",
    "Paket 7 Hari",
    "Paket 14 Hari",
  ];

  // Harga (Contoh Harian, disesuaikan dengan durasi)
  final Map<String, Map<String, int>> priceTable = {
    // Harga Boarding (Contoh: Kucing/Anjing)
    'Kucing': {
      'Paket 1 Hari': 50000,
      'Paket 3 Hari': 140000, // Lebih murah sedikit dari 3 x 50.000
      'Paket 7 Hari': 300000, // Diskon 15% dari 7 x 50.000
      'Paket 14 Hari': 550000, // Diskon 21% dari 14 x 50.000
    },
    'Anjing': {
      'Paket 1 Hari': 65000,
      'Paket 3 Hari': 190000,
      'Paket 7 Hari': 420000,
      'Paket 14 Hari': 800000,
    },
  };

  // Detail Konten Paket Boarding (Sesuai permintaan Anda)
  final Map<String, Map<String, dynamic>> packageDetails = {
    'Paket 1 Hari': {
      'short':
          'Penitipan 24 jam untuk kebutuhan mendadak. Termasuk makan 1-2x dan playtime 1x.',
      'full': [
        'Penitipan 24 jam',
        'Makan 1–2 kali',
        'Playtime 1x',
        'Update foto 1x',
        'Pembersihan kandang harian',
        'Pemeriksaan kondisi dasar',
      ],
    },
    'Paket 3 Hari': {
      'short':
          'Penitipan jangka pendek 3x24 jam. Playtime 2x sehari dan basic grooming ringan.',
      'full': [
        'Penitipan 3×24 jam',
        'Makan sesuai jadwal',
        'Playtime 2x sehari',
        'Update foto/video 1–2x sehari',
        'Basic grooming ringan',
        'Pembersihan kandang rutin',
        'Monitoring kondisi harian',
      ],
    },
    'Paket 7 Hari': {
      'short':
          'Penitipan 1 minggu dengan diet custom, daily activity report, dan ruangan nyaman.',
      'full': [
        'Penitipan 7×24 jam',
        'Diet custom (bisa bawa makanan sendiri)',
        'Playtime 2–3x sehari',
        'Update foto/video harian',
        'Daily activity report',
        'Basic grooming mingguan',
        'Ruangan nyaman (kasur, mainan)',
        'Monitoring intensif oleh pet handler',
      ],
    },
    'Paket 14 Hari': {
      'short':
          'Penitipan 2 minggu (jangka panjang) dengan monitoring intensif dan pemeriksaan fisik mingguan.',
      'full': [
        'Penitipan 14×24 jam',
        'Diet custom & feeding sesuai jadwal',
        'Playtime 2–3x sehari',
        'Update foto/video 2x sehari',
        'Laporan aktivitas harian lengkap',
        'Basic grooming mingguan + perapian tambahan',
        'Ruangan lebih nyaman (kasur empuk, enrichment toys)',
        'Monitoring intensif oleh pet handler',
        'Pemeriksaan fisik ringan mingguan (gigi, telinga, bulu)',
        'Cocok untuk: Liburan panjang, dinas luar kota lama, atau pemilik yang ingin penitipan full-service jangka panjang.',
      ],
    },
  };

  // Kode promo yang tersedia
  final Map<String, double> promoCodes = {
    'BOARDING10': 0.10, // 10% diskon
    'PETCARE15': 0.15, // 15% diskon
    'WEEKEND20': 0.20, // 20% diskon
  };

  // Logika Harga
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

  // Helper Functions
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  String formatPrice(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  // ================================
  // 🔥 SAVE ORDER FIREBASE DISINI
  // ================================
  Future<void> saveBoardingOrder() async {
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
      "serviceType": "boarding",
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

    Get.toNamed('/boarding-payment', arguments: orderRef.id);
  }
}
