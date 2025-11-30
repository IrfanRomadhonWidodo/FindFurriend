// lib/controllers/admin/admin_profile_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminProfileController extends GetxController {
  var isLoading = false.obs;
  var isEditing = false.obs;

  // Form fields
  var name = ''.obs;
  var email = ''.obs;
  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  // Error messages
  var nameError = ''.obs;
  var emailError = ''.obs;
  var currentPasswordError = ''.obs;
  var newPasswordError = ''.obs;
  var confirmPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdminData();
  }

  Future<void> fetchAdminData() async {
    try {
      isLoading(true);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        email.value = user.email ?? '';

        // Fetch admin data from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          name.value = doc.data()?['name'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching admin data: $e');
    } finally {
      isLoading(false);
    }
  }

  void validateName() {
    if (name.value.isEmpty) {
      nameError.value = 'Nama tidak boleh kosong';
    } else if (name.value.length < 3) {
      nameError.value = 'Nama minimal 3 karakter';
    } else {
      nameError.value = '';
    }
  }

  void validateEmail() {
    if (email.value.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
    } else if (!GetUtils.isEmail(email.value)) {
      emailError.value = 'Email tidak valid';
    } else {
      emailError.value = '';
    }
  }

  void validateCurrentPassword() {
    if (currentPassword.value.isEmpty) {
      currentPasswordError.value = 'Password saat ini tidak boleh kosong';
    } else {
      currentPasswordError.value = '';
    }
  }

  void validateNewPassword() {
    if (newPassword.value.isNotEmpty && newPassword.value.length < 6) {
      newPasswordError.value = 'Password minimal 6 karakter';
    } else {
      newPasswordError.value = '';
    }
  }

  void validateConfirmPassword() {
    if (newPassword.value.isNotEmpty) {
      if (confirmPassword.value.isEmpty) {
        confirmPasswordError.value = 'Konfirmasi password tidak boleh kosong';
      } else if (newPassword.value != confirmPassword.value) {
        confirmPasswordError.value = 'Password tidak cocok';
      } else {
        confirmPasswordError.value = '';
      }
    } else {
      confirmPasswordError.value = '';
    }
  }

  bool get isFormValid {
    validateName();
    validateEmail();

    if (currentPassword.value.isNotEmpty || newPassword.value.isNotEmpty) {
      validateCurrentPassword();
      validateNewPassword();
      validateConfirmPassword();
    }

    return nameError.isEmpty &&
        emailError.isEmpty &&
        currentPasswordError.isEmpty &&
        newPasswordError.isEmpty &&
        confirmPasswordError.isEmpty;
  }

  Future<void> updateProfile() async {
    if (!isFormValid) return;

    try {
      isLoading(true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not found";

      // Update email if changed
      if (email.value != user.email) {
        await user.updateEmail(email.value);
      }

      // Update password if provided
      if (newPassword.value.isNotEmpty) {
        await user.updatePassword(newPassword.value);
      }

      // Update admin data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'name': name.value,
            'email': email.value,
            'updatedAt': DateTime.now().toIso8601String(),
          });

      isEditing.value = false;

      // Clear password fields
      currentPassword.value = '';
      newPassword.value = '';
      confirmPassword.value = '';

      Get.snackbar(
        "Sukses",
        "Profil berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memperbarui profil: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;

    // If canceling edit, reset form
    if (!isEditing.value) {
      fetchAdminData();
      currentPassword.value = '';
      newPassword.value = '';
      confirmPassword.value = '';
      nameError.value = '';
      emailError.value = '';
      currentPasswordError.value = '';
      newPasswordError.value = '';
      confirmPasswordError.value = '';
    }
  }
}
