import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  // Kode promo yang tersedia (diskon dalam persentase)
  Map<String, double> promoCodes = {
    "FINDFURRIEND99": 0.10, // Diskon 10%
    "PETCARE20": 0.15, // Diskon 15%
    "GROOMING15": 0.20, // Diskon 20%
  };

  // Harga asli sebelum diskon
  int get originalPrice {
    return priceTable[selectedPet.value]?[selectedPackage.value] ?? 0;
  }

  // Total harga setelah diskon
  int get totalPrice {
    double price = originalPrice.toDouble();

    // Cek apakah kode promo valid
    if (promoCode.value.isNotEmpty &&
        promoCodes.containsKey(promoCode.value.toUpperCase())) {
      double discountPercentage = promoCodes[promoCode.value.toUpperCase()]!;
      price = price * (1 - discountPercentage);
    }

    return price.round();
  }

  // Mendapatkan persentase diskon
  double get discountPercentage {
    if (promoCode.value.isNotEmpty &&
        promoCodes.containsKey(promoCode.value.toUpperCase())) {
      return promoCodes[promoCode.value.toUpperCase()]!;
    }
    return 0.0;
  }

  // Mendapatkan nominal diskon
  int get discountAmount {
    if (promoCode.value.isNotEmpty &&
        promoCodes.containsKey(promoCode.value.toUpperCase())) {
      return (originalPrice * discountPercentage).round();
    }
    return 0;
  }

  // Mengecek apakah kode promo valid
  bool get isPromoValid {
    return promoCode.value.isNotEmpty &&
        promoCodes.containsKey(promoCode.value.toUpperCase());
  }

  String formatPrice(int price) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(price);
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }
}
