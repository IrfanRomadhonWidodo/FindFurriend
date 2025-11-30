// lib/controllers/training/training_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingController extends GetxController {
  // Observables (State Management)
  final selectedPet =
      'Kucing'.obs; // Default value seperti di DaycareController
  final selectedDate = DateTime.now().obs;
  final selectedPackage = 'Paket Training 1'.obs; // Default value
  final promoCode = ''.obs;

  // Data Statis untuk View
  final pets = ["Kucing", "Anjing"];
  final packageNames = ["Paket Training 1", "Paket Training 2"];

  // --- HARGA YANG SUDAH DIPEBARUI ---
  final Map<String, Map<String, int>> priceTable = {
    // Menggunakan harga yang sama untuk Kucing dan Anjing
    'Kucing': {'Paket Training 1': 120000, 'Paket Training 2': 200000},
    'Anjing': {'Paket Training 1': 120000, 'Paket Training 2': 200000},
  };
  // ------------------------------------

  // Detail Konten Paket Training (TETAP SAMA)
  final Map<String, List<String>> fullPackageDetails = {
    'Paket Training 1': [
      '8 pertemuan',
      'Durasi program: 2 bulan',
      'Durasi tiap pertemuan: 2 jam',
      'Gambaran kegiatan tiap pertemuan:',
      '  - Pemanasan & bonding (5–10 menit)',
      '  - Latihan obedience dasar (sit, stay, down, come)',
      '  - Latihan kontrol emosi ringan',
      '  - Latihan jalan dengan leash tanpa tarik-tarikan',
      '  - Sesi evaluasi singkat di akhir training',
      '  - PR ringan untuk owner selama di rumah',
      'Cocok untuk: Puppy/kitten atau hewan dewasa yang belum pernah training dan butuh pondasi dasar.',
    ],
    'Paket Training 2': [
      '16 pertemuan',
      'Durasi program: 2 bulan',
      'Durasi tiap pertemuan: 2 jam',
      'Gambaran kegiatan tiap pertemuan:',
      '  - Pemanasan & fokus',
      '  - Obedience lengkap (sit, stay, come, down, heel, no, leave it)',
      '  - Latihan di area dengan distraksi (lingkungan lebih ramai)',
      '  - Peningkatan kontrol (off-leash basics, recall lebih jauh)',
      '  - Socialization training (jika memungkinkan)',
      '  - Correction untuk perilaku bermasalah (ringan)',
      '  - Evaluasi & progres mingguan',
      'Cocok untuk: Hewan yang sudah punya dasar atau pemilik yang ingin hasil training lebih komplit dan stabil.',
    ],
  };

  // Detail Ringkas untuk ditampilkan di card paket (TETAP SAMA)
  final Map<String, String> shortPackageDetails = {
    'Paket Training 1':
        '8 pertemuan, 2 jam/sesi. Obedience dasar, kontrol emosi ringan, cocok untuk pondasi dasar.',
    'Paket Training 2':
        '16 pertemuan, 2 jam/sesi. Obedience lengkap, latihan distraksi, koreksi perilaku ringan.',
  };

  final String durationDetails =
      'Setiap sesi: 2 jam. Kegiatan bisa dibagi misalnya:\n'
      '• 15 menit bonding + fokus\n'
      '• 60–80 menit training inti\n'
      '• 20–25 menit evaluasi & PR untuk owner';

  // Kode promo (mengikuti pola DaycareController)
  final Map<String, double> promoCodes = {
    "TRAINING10": 0.10,
    "PETCARE15": 0.15,
    "TRAINING20": 0.20,
  };

  // --- Logic Perhitungan Harga (Mengikuti Pola DaycareController) ---

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

  // --- Logic View/Helper (Mengikuti Pola DaycareController) ---

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
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  // ================================
  // 🔥 SAVE ORDER FIREBASE DISINI
  // ================================
  Future<void> saveTrainingOrder() async {
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
      "serviceType": "training",
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

    Get.toNamed('/training-payment', arguments: orderRef.id);
  }
}
