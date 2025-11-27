// lib/controllers/boarding/boarding_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BoardingController extends GetxController {
  // Observables (State Management)
  final selectedPet = ''.obs;
  final selectedDate = DateTime.now().obs;
  final selectedPackage = ''.obs;
  final promoCode = ''.obs;
  
  // Data Statis untuk View
  final pets = ["Kucing", "Anjing"];
  final packageNames = ["Paket 1 Hari", "Paket 3 Hari", "Paket 7 Hari", "Paket 14 Hari"];

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
        'short': 'Penitipan 24 jam untuk kebutuhan mendadak. Termasuk makan 1-2x dan playtime 1x.',
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
        'short': 'Penitipan jangka pendek 3x24 jam. Playtime 2x sehari dan basic grooming ringan.',
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
        'short': 'Penitipan 1 minggu dengan diet custom, daily activity report, dan ruangan nyaman.',
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
        'short': 'Penitipan 2 minggu (jangka panjang) dengan monitoring intensif dan pemeriksaan fisik mingguan.',
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

  // Logika Harga
  int get originalPrice {
    final pet = selectedPet.value;
    final pkg = selectedPackage.value;
    return priceTable[pet]?[pkg] ?? 0;
  }

  final double discountPercentage = 0.10; // Contoh diskon 10%
  
  bool get isPromoValid {
    // Asumsi promo "BOARDING10"
    return promoCode.value.toUpperCase() == 'BOARDING10' && originalPrice > 0;
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

  void saveBoardingOrder() {
    Get.snackbar(
      "Berhasil!",
      "Pesanan Boarding ${selectedPackage.value} (${selectedPet.value}) berhasil dibuat. Total: ${formatPrice(totalPrice)}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // Get.toNamed('/upload-payment');
  }
}