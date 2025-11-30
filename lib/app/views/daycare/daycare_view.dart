// lib/views/daycare/daycare_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/daycare/daycare_controller.dart';

class DaycareView extends StatelessWidget {
  DaycareView({Key? key}) : super(key: key);

  final DaycareController controller = Get.put(DaycareController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Layanan Day Care"),
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/daycare/400/200.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.orange.shade100,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.orange.shade100,
                  child: const Center(
                    child: Icon(Icons.pets, size: 80, color: Colors.orange),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Jenis Peliharaan
            const Text(
              "Jenis Peliharaan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => Row(
                children: controller.pets.map((pet) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedPet.value = pet,
                      child: Container(
                        margin: EdgeInsets.only(
                          right: pet == "Kucing" ? 10 : 0,
                        ),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: controller.selectedPet.value == pet
                              ? Colors.orange.shade50
                              : Colors.white,
                          border: Border.all(
                            color: controller.selectedPet.value == pet
                                ? Colors.orange
                                : Colors.grey.shade300,
                            width: controller.selectedPet.value == pet ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                pet == "Kucing"
                                    ? Icons.pets
                                    : Icons.cruelty_free,
                                color: Colors.orange,
                                size: 45,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              pet,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: controller.selectedPet.value == pet
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: controller.selectedPet.value == pet
                                    ? Colors.orange
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 25),

            // Tanggal Day Care
            const Text(
              "Tanggal Day Care",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => GestureDetector(
                onTap: () => controller.selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat(
                          'dd MMMM yyyy',
                        ).format(controller.selectedDate.value),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.orange),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Pilih Paket Day Care
            const Text(
              "Pilih Paket Day Care (Durasi)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => Column(
                children: controller.packageNames.map((pkg) {
                  return GestureDetector(
                    onTap: () => controller.selectedPackage.value = pkg,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: controller.selectedPackage.value == pkg
                              ? Colors.orange
                              : Colors.grey.shade300,
                          width: controller.selectedPackage.value == pkg
                              ? 2
                              : 1,
                        ),
                        color: controller.selectedPackage.value == pkg
                            ? Colors.orange.shade50
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            // Package image
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getPackageIcon(pkg),
                                color: Colors.orange,
                                size: 35,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        pkg,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              controller
                                                      .selectedPackage
                                                      .value ==
                                                  pkg
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color:
                                              controller
                                                      .selectedPackage
                                                      .value ==
                                                  pkg
                                              ? Colors.orange
                                              : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        controller.formatPrice(
                                          controller.priceTable[controller
                                                  .selectedPet
                                                  .value]?[pkg] ??
                                              0,
                                        ),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              controller
                                                      .selectedPackage
                                                      .value ==
                                                  pkg
                                              ? Colors.orange
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.packageDetails[pkg]?['short'] ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 25),

            // Jarak Antar Jemput
            const Text(
              "Jarak Lokasi (km)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: "Masukkan jarak lokasi Anda (misalnya: 3.5)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
              onChanged: (v) {
                // Mengambil nilai desimal dari input dan memperbarui controller
                final distance = double.tryParse(v) ?? 0.0;
                controller.distanceInKm.value = distance;
              },
            ),

            const SizedBox(height: 25),

            // Kode Promo (tanpa daftar kode)
            const Text(
              "Kode Promo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Masukkan kode promo",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
              onChanged: (v) => controller.promoCode.value = v,
            ),

            const SizedBox(height: 20),

            // Total dengan detail diskon seperti Gojek/Grab
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Harga Paket
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Harga Paket",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          controller.formatPrice(controller.originalPrice),
                          style: TextStyle(
                            fontSize: 14,
                            color: controller.isPromoValid
                                ? Colors.grey
                                : Colors.black87,
                            decoration: controller.isPromoValid
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),

                    // Biaya Jarak (Delivery)
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Biaya Jarak (Delivery)",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          controller.formatPrice(controller.deliveryFee),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    // Diskon (hanya muncul jika ada promo valid)
                    if (controller.isPromoValid) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_offer,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Diskon ${controller.discountPercentage * 100}%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "-${controller.formatPrice(controller.discountAmount)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Total akhir
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          controller.formatPrice(controller.totalPrice),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Checkout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedPet.isEmpty ||
                      controller.selectedDate.value == null ||
                      controller.selectedPackage.isEmpty ||
                      controller.distanceInKm.value <= 0) {
                    Get.snackbar(
                      "Error",
                      "Lengkapi seluruh data (termasuk jarak) terlebih dahulu",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  controller.saveDaycareOrder(); // <<-- INI TAMBAH
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Checkout",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Icons Day Care ---
  IconData _getPackageIcon(String pkgName) {
    if (pkgName.contains('Mini')) return Icons.alarm;
    if (pkgName.contains('Half-Day')) return Icons.schedule;
    if (pkgName.contains('Full-Day')) return Icons.watch_later;
    return Icons.pets;
  }
}
