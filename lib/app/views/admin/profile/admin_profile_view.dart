// lib/views/admin/profile/admin_profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../controllers/admin/admin_profile_controller.dart';

class AdminProfileView extends StatelessWidget {
  const AdminProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminProfileController controller = Get.put(AdminProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Pengaturan Admin"),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(controller.isEditing.value ? Icons.close : Icons.edit),
              onPressed: controller.toggleEdit,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.name.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade400,
                            Colors.orange.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => Text(
                        controller.name.value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Administrator',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Profile Form
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                      'Informasi Akun',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name Field
                    Obx(
                      () => TextFormField(
                        initialValue: controller.name.value,
                        enabled: controller.isEditing.value,
                        onChanged: (value) => controller.name.value = value,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: controller.nameError.value.isNotEmpty
                              ? controller.nameError.value
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Email Field
                    Obx(
                      () => TextFormField(
                        initialValue: controller.email.value,
                        enabled: controller.isEditing.value,
                        onChanged: (value) => controller.email.value = value,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: controller.emailError.value.isNotEmpty
                              ? controller.emailError.value
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Password Fields (only show in edit mode)
                    Obx(
                      () => controller.isEditing.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  obscureText: true,
                                  onChanged: (value) =>
                                      controller.currentPassword.value = value,
                                  decoration: InputDecoration(
                                    labelText:
                                        'Password Saat Ini (Kosongkan jika tidak ingin mengubah)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText:
                                        controller
                                            .currentPasswordError
                                            .value
                                            .isNotEmpty
                                        ? controller.currentPasswordError.value
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  obscureText: true,
                                  onChanged: (value) =>
                                      controller.newPassword.value = value,
                                  decoration: InputDecoration(
                                    labelText: 'Password Baru (Opsional)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText:
                                        controller
                                            .newPasswordError
                                            .value
                                            .isNotEmpty
                                        ? controller.newPasswordError.value
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  obscureText: true,
                                  onChanged: (value) =>
                                      controller.confirmPassword.value = value,
                                  decoration: InputDecoration(
                                    labelText: 'Konfirmasi Password Baru',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText:
                                        controller
                                            .confirmPasswordError
                                            .value
                                            .isNotEmpty
                                        ? controller.confirmPasswordError.value
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Save Button (only show in edit mode)
                    Obx(
                      () => controller.isEditing.value
                          ? SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Simpan Perubahan",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // About App
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),

                    ListTile(
                      leading: const Icon(Icons.info, color: Colors.orange),
                      title: const Text('Informasi Aplikasi'),
                      subtitle: const Text('Versi dan informasi developer'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Tentang Aplikasi"),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "FindFurriend App",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text("Versi: 1.0.0"),
                                SizedBox(height: 10),
                                Text("Deskripsi:"),
                                Text(
                                  "Aplikasi layanan perawatan hewan peliharaan yang menyediakan berbagai layanan seperti grooming, daycare, boarding, dan training untuk hewan kesayangan Anda.",
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Dikembangkan oleh:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Tim FindFurriend"),
                                SizedBox(height: 10),
                                Text(
                                  "Hak Cipta © 2025 FindFurriend. Semua hak dilindungi.",
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text("Tutup"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.contact_support,
                        color: Colors.orange,
                      ),
                      title: const Text('Bantuan & Dukungan'),
                      subtitle: const Text('Hubungi tim dukungan kami'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Bantuan & Dukungan"),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hubungi kami:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text("Email: support@findfurriend.com"),
                                SizedBox(height: 5),
                                Text("Telepon: (021) 1234-5678"),
                                SizedBox(height: 5),
                                Text(
                                  "Jam Operasional: Senin - Jumat, 09:00 - 17:00 WIB",
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Untuk bantuan teknis atau pertanyaan seputar layanan, silakan hubungi kami melalui kontak di atas.",
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text("Tutup"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Konfirmasi Logout"),
                        content: const Text("Apakah Anda yakin ingin logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Logout logic here
                              await FirebaseAuth.instance.signOut();
                              Get.back();
                              Get.offAllNamed('/login');
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
