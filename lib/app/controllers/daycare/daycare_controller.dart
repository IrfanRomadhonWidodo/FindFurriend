// lib/controllers/daycare/daycare_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaycareController extends GetxController {
  // Observables (State Management)
  final selectedPet = 'Kucing'.obs;
  final selectedDate = DateTime.now().obs;
  final selectedPackage = 'Paket Mini'.obs;
  final promoCode = ''.obs;
  final distanceInKm = 0.0.obs;

  // Data Statis untuk View
  final pets = ["Kucing", "Anjing"];
  final packageNames = ["Paket Mini", "Paket Half-Day", "Paket Full-Day"];

  // Harga (Contoh: Kucing/Anjing per durasi)
  final Map<String, Map<String, int>> priceTable = {
    'Kucing': {
      'Paket Mini': 30000,
      'Paket Half-Day': 55000,
      'Paket Full-Day': 90000,
    },
    'Anjing': {
      'Paket Mini': 45000,
      'Paket Half-Day': 80000,
      'Paket Full-Day': 130000,
    },
  };

  // Detail Konten Paket Daycare (Sesuai permintaan Anda)
  final Map<String, Map<String, dynamic>> packageDetails = {
    'Paket Mini': {
      'short':
          'Durasi 1-2 Jam. Hanya butuh anabul dijaga sebentar atau jalan-jalan singkat.',
      'full': [
        'Cocok untuk:',
        'Owner yang cuma butuh anabul dijagain sebentar',
        'Butuh anabul dijemput jalan-jalan singkat',
        'Aktivitas ringan, bukan full stay',
        'Kegiatan:',
        'Jalan-jalan 15–20 menit',
        'Main ringan di area daycare',
        'Update foto/video',
        'Kenapa efisien?',
        'Cepat, turnover tinggi',
        'Tidak butuh space besar',
      ],
    },
    'Paket Half-Day': {
      'short':
          'Durasi 4 Jam. Cocok untuk owner kerja part-time, termasuk sosialisasi & aktivitas lebih lama.',
      'full': [
        'Cocok untuk:',
        'Owner kerja part-time',
        'Anabul yang butuh sosialisasi & aktivitas lebih lama',
        'Kegiatan:',
        'Jalan-jalan 30 menit',
        'Waktu bermain di daycare',
        'Stimulasi ringan (toys, puzzle feeder)',
        'Monitoring dan update foto/video',
        'Value:',
        'Durasi menengah → masih manageable buat staff',
        'Bisa dibuat sesi pagi & sore',
      ],
    },
    'Paket Full-Day': {
      'short':
          'Durasi 8 Jam. Cocok untuk owner full-time. Termasuk walking session, nap time, dan report harian.',
      'full': [
        'Cocok untuk:',
        'Owner kerja full-time',
        'Anabul yang aktif & butuh pengawasan lama',
        'Kegiatan:',
        '1x walking session (30–45 menit)',
        'Sesi bermain terjadwal',
        'Nap time',
        'Feeding (opsional, owner bawa makanan)',
        'Report harian',
        'Keunggulan:',
        'Bisa jadi paket premium',
        'Operasional stabil (anabul stay lebih lama → tidak bolak balik)',
      ],
    },
  };

  // Kode promo
  final Map<String, double> promoCodes = {
    "DAYCARE10": 0.10,
    "PETCARE15": 0.15,
    "DAYCARE20": 0.20,
  };

  // Logika Harga
  int get originalPrice {
    final pet = selectedPet.value;
    final pkg = selectedPackage.value;
    return priceTable[pet]?[pkg] ?? 0;
  }

  int get totalPrice {
    double price = originalPrice.toDouble();
    if (promoCodes.containsKey(promoCode.value.toUpperCase())) {
      price *= (1 - promoCodes[promoCode.value.toUpperCase()]!);
    }
    return price.round() + deliveryFee;
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

  int get deliveryFee {
    final distance = distanceInKm.value;
    if (distance > 0 && distance <= 2.0) {
      return 0; // Gratis
    } else if (distance > 2.0 && distance <= 5.0) {
      return 10000;
    } else if (distance > 5.0 && distance <= 10.0) {
      return 15000;
    } else if (distance > 10.0 && distance <= 20.0) {
      return 25000;
    } else if (distance > 20.0) {
      return 40000;
    }
    return 0;
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
  Future<void> saveDaycareOrder() async {
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
      "serviceType": "daycare",
      "pet": selectedPet.value,
      "package": selectedPackage.value,
      "originalPrice": originalPrice,
      "discount": discountAmount,
      "totalPrice": totalPrice,
      "promoCode": promoCode.value,
      "distance": distanceInKm.value,
      "deliveryFee": deliveryFee,
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

    Get.toNamed('/daycare-payment', arguments: orderRef.id);
  }
}
