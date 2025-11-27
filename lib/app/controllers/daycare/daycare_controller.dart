// lib/controllers/daycare/daycare_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaycareController extends GetxController {
  // Observables (State Management)
  final selectedPet = ''.obs;
  final selectedDate = DateTime.now().obs;
  final selectedPackage = ''.obs;
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
        'short': 'Durasi 1-2 Jam. Hanya butuh anabul dijaga sebentar atau jalan-jalan singkat.',
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
        'short': 'Durasi 4 Jam. Cocok untuk owner kerja part-time, termasuk sosialisasi & aktivitas lebih lama.',
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
        'short': 'Durasi 8 Jam. Cocok untuk owner full-time. Termasuk walking session, nap time, dan report harian.',
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

  // Logika Harga
  int get originalPrice {
    final pet = selectedPet.value;
    final pkg = selectedPackage.value;
    return priceTable[pet]?[pkg] ?? 0;
  }

  final double discountPercentage = 0.15; // Contoh diskon 15%
  
  bool get isPromoValid {
    // Asumsi promo "DAYCARE15"
    return promoCode.value.toUpperCase() == 'DAYCARE15' && originalPrice > 0;
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

  int get discountAmount {
    if (isPromoValid) {
      return (originalPrice * discountPercentage).toInt();
    }
    return 0;
  }

  int get totalPrice {
    return originalPrice - discountAmount + deliveryFee;
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
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  void saveDaycareOrder() {
    Get.snackbar(
      "Berhasil!",
      "Pesanan Daycare ${selectedPackage.value} (${selectedPet.value}) berhasil dibuat. Total: ${formatPrice(totalPrice)}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // Get.toNamed('/upload-payment');
  }
}