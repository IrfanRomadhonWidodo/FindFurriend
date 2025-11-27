// lib/controllers/training/training_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrainingController extends GetxController {
  // Observables (State Management)
  final selectedPet = ''.obs;
  final selectedDate = DateTime.now().obs;
  final selectedPackage = ''.obs;
  final promoCode = ''.obs;
  
  // Data Statis untuk View
  final pets = ["Kucing", "Anjing"];
  final packageNames = ["Paket Training 1", "Paket Training 2"];

  // --- HARGA YANG SUDAH DIPEBARUI ---
  final Map<String, Map<String, int>> priceTable = {
    // Menggunakan harga yang sama untuk Kucing dan Anjing
    'Kucing': {
      'Paket Training 1': 120000, 
      'Paket Training 2': 200000, 
    },
    'Anjing': {
      'Paket Training 1': 120000, 
      'Paket Training 2': 200000, 
    },
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
    'Paket Training 1': '8 pertemuan, 2 jam/sesi. Obedience dasar, kontrol emosi ringan, cocok untuk pondasi dasar.',
    'Paket Training 2': '16 pertemuan, 2 jam/sesi. Obedience lengkap, latihan distraksi, koreksi perilaku ringan.',
  };
  
  final String durationDetails = 
      'Setiap sesi: 2 jam. Kegiatan bisa dibagi misalnya:\n'
      '• 15 menit bonding + fokus\n'
      '• 60–80 menit training inti\n'
      '• 20–25 menit evaluasi & PR untuk owner';


  // --- Logic Perhitungan Harga (Mengikuti Pola Grooming Controller) ---

  int get originalPrice {
    final pet = selectedPet.value;
    final pkg = selectedPackage.value;
    return priceTable[pet]?[pkg] ?? 0;
  }

  final double discountPercentage = 0.20; 

  bool get isPromoValid {
    // Asumsi promo "TRAINING20"
    return promoCode.value.toUpperCase() == 'TRAINING20' && originalPrice > 0;
  }

  int get discountAmount {
    if (isPromoValid) {
      return (originalPrice * discountPercentage).toInt();
    }
    return 0;
  }

  int get totalPrice {
    return originalPrice - discountAmount;
  }

  // --- Logic View/Helper (Mengikuti Pola Grooming Controller) ---

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

  void saveTrainingOrder() {
    Get.snackbar(
      "Berhasil!",
      "Pesanan Training ${selectedPackage.value} (${selectedPet.value}) berhasil dibuat. Total: ${formatPrice(totalPrice)}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // Get.toNamed('/upload-payment');
  }
}