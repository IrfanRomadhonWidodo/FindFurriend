// lib/views/boarding/boarding_payment_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // buat cek kIsWeb
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/boarding/boarding_payment_controller.dart';
import 'dart:io';

class BoardingPaymentView extends StatelessWidget {
  BoardingPaymentView({super.key});

  final BoardingPaymentController controller = Get.put(
    BoardingPaymentController(),
  );

  @override
  Widget build(BuildContext context) {
    final String orderId = Get.arguments ?? '';

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F5F5,
      ), // Disesuaikan dengan GroomingView
      appBar: AppBar(
        title: const Text("Upload Bukti Pembayaran"), // Menghapus GoogleFonts
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Disesuaikan dengan GroomingView
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (controller.paymentDetails.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Details Card - Disesuaikan desainnya
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rincian Pembayaran",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Order ID
                    _buildDetailRow(
                      "ID Pesanan",
                      controller.paymentDetails['orderId'],
                    ),
                    const SizedBox(height: 10),

                    // Service Name
                    _buildDetailRow(
                      "Layanan",
                      controller.paymentDetails['serviceName'],
                    ),
                    const SizedBox(height: 10),

                    // Duration (Boarding specific)
                    _buildDetailRow(
                      "Durasi",
                      controller.paymentDetails['duration'],
                    ),
                    const SizedBox(height: 10),

                    // Date & Time
                    _buildDetailRow(
                      "Tanggal Mulai",
                      "${controller.paymentDetails['date']}",
                    ),
                    const SizedBox(height: 10),

                    // Payment Method
                    _buildDetailRow(
                      "Metode Pembayaran",
                      controller.paymentDetails['paymentMethod'],
                    ),
                    const SizedBox(height: 15),

                    // Divider
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 15),

                    // Bank Details
                    const Text(
                      "Informasi Transfer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildDetailRow(
                      "Bank",
                      controller.paymentDetails['bankName'],
                    ),
                    const SizedBox(height: 10),

                    _buildDetailRow(
                      "No. Rekening",
                      controller.paymentDetails['accountNumber'],
                    ),
                    const SizedBox(height: 10),

                    _buildDetailRow(
                      "Atas Nama",
                      controller.paymentDetails['accountName'],
                    ),
                    const SizedBox(height: 15),

                    // Divider
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 15),

                    // Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Pembayaran",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Rp ${_formatCurrency(controller.paymentDetails['price'])}",
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

              const SizedBox(height: 25),

              // Upload Instructions - Disesuaikan desainnya
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text(
                          "Petunjuk Pembayaran",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "1. Transfer sesuai jumlah total pembayaran\n"
                      "2. Ambil foto/scan bukti transfer\n"
                      "3. Upload bukti pembayaran menggunakan tombol di bawah",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Image Preview
              if (controller.selectedImage.value != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: kIsWeb
                        ? Image.network(
                            controller.selectedImage.value!.path,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(controller.selectedImage.value!.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

              const SizedBox(height: 20),

              // Pilih file button - Disesuaikan desainnya
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.pickImage,
                  icon: const Icon(Icons.file_upload),
                  label: Text(
                    controller.fileSelected.value
                        ? "Ganti Bukti Pembayaran"
                        : "Pilih Bukti Pembayaran",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Info file terpilih - Disesuaikan desainnya
              if (controller.fileSelected.value)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade300),
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
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "✔ File berhasil dipilih",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade300),
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
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Belum ada file dipilih",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 25),

              // Tombol upload - Disesuaikan desainnya
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.uploadPaymentProof(orderId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              "Mengupload...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          "Upload Sekarang",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "-",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(dynamic price) {
    if (price == null) return "-";
    try {
      int value = int.parse(price.toString());
      return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => "${m[1]}.",
      );
    } catch (e) {
      return price.toString();
    }
  }
}
