// lib/views/training/training_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Sesuaikan path import controller jika diperlukan
import '../../controllers/training/training_controller.dart';

class TrainingView extends StatelessWidget {
  TrainingView({Key? key}) : super(key: key);

  final TrainingController controller = Get.put(TrainingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Layanan Training"),
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
            // --- Header Image ---
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/training/400/200.jpg',
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
                    child: Icon(Icons.school, size: 80, color: Colors.orange),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- 1. Jenis Peliharaan ---
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

            // --- 2. Tanggal Training ---
            const Text(
              "Tanggal Training",
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

            // --- 3. Pilih Paket Training ---
            const Text(
              "Pilih Paket Training",
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
                  final price =
                      controller.priceTable[controller
                          .selectedPet
                          .value]?[pkg] ??
                      0;
                  final shortDetail =
                      controller.shortPackageDetails[pkg] ??
                      'Detail tidak tersedia';
                  final fullDetails = controller.fullPackageDetails[pkg] ?? [];

                  return _buildPackageCard(
                    packageName: pkg,
                    price: price,
                    shortDetail: shortDetail,
                    fullDetails: fullDetails,
                    isSelected: controller.selectedPackage.value == pkg,
                    onTap: () => controller.selectedPackage.value = pkg,
                    icon: _getPackageIcon(pkg),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 25),

            // --- Detail Durasi Meeting ---
            const Text(
              "🕒 Durasi Meeting",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
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
                children: [
                  const Icon(Icons.timer, color: Colors.orange, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.durationDetails,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- Kode Promo ---
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
                prefixIcon: const Icon(Icons.local_offer, color: Colors.orange),
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

            // Total box
            Obx(() => _buildTotalBox(controller)),

            const SizedBox(height: 30),

            // Checkout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedPet.isEmpty ||
                      controller.selectedDate.value == null ||
                      controller.selectedPackage.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Lengkapi seluruh data terlebih dahulu",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  controller.saveTrainingOrder();
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

  // --- Helper Widgets ---

  Widget _buildPackageCard({
    required String packageName,
    required int price,
    required String shortDetail,
    required List<String> fullDetails,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.orange.shade50 : Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Utama Card (Nama dan Harga)
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.orange, size: 35),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              packageName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.black87,
                              ),
                            ),
                            Text(
                              controller.formatPrice(price),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shortDetail,
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

              // Detail Tambahan yang Meluas (Hanya muncul jika paket ini dipilih)
              if (isSelected) ...[
                const SizedBox(height: 15),
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 15),

                const Text(
                  "Detail Paket:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),

                // Daftar Poin Detail
                ...fullDetails.map((detail) {
                  bool isSubDetail = detail.trim().startsWith('-');
                  bool isHeader = detail.endsWith(':');
                  return Padding(
                    padding: EdgeInsets.only(
                      left: isSubDetail ? 16.0 : 0.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      isSubDetail ? detail : (isHeader ? detail : '• $detail'),
                      style: TextStyle(
                        fontSize: isSubDetail ? 13 : 14,
                        fontStyle: detail.startsWith('Cocok untuk:')
                            ? FontStyle.italic
                            : FontStyle.normal,
                        fontWeight: isHeader
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBox(TrainingController controller) {
    return Container(
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
          // Harga asli
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Harga",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              Text(
                controller.formatPrice(controller.originalPrice),
                style: TextStyle(
                  fontSize: 14,
                  color: controller.isPromoValid ? Colors.grey : Colors.black87,
                  decoration: controller.isPromoValid
                      ? TextDecoration.lineThrough
                      : null,
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
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
                Text(
                  "-${controller.formatPrice(controller.discountAmount)}",
                  style: const TextStyle(fontSize: 14, color: Colors.green),
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
    );
  }

  // --- Helper Icons ---
  IconData _getPackageIcon(String pkgName) {
    if (pkgName.contains("Paket Training 1")) return Icons.school;
    if (pkgName.contains("Paket Training 2")) return Icons.auto_stories;
    if (pkgName.contains("Paket Training 3")) return Icons.psychology;
    return Icons.pets;
  }
}
