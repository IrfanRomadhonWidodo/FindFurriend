// lib/controllers/admin/admin_services_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminServicesController extends GetxController {
  var isLoading = true.obs;

  // Articles data
  var articles = [].obs;

  // Form data for article
  var articleTitle = ''.obs;
  var articleLink = ''.obs;
  var articleImage = ''.obs;
  var articleStatus = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading(true);

      final articlesSnapshot = await FirebaseFirestore.instance
          .collection('articles')
          .orderBy('createdAt', descending: true)
          .get();

      articles.value = articlesSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching articles: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addArticle() async {
    try {
      isLoading(true);

      await FirebaseFirestore.instance.collection('articles').add({
        'title': articleTitle.value,
        'link': articleLink.value,
        'image': articleImage.value,
        'status': articleStatus.value,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Reset form
      resetArticleForm();

      // Refresh data
      fetchArticles();

      Get.back();
      Get.snackbar(
        "Sukses",
        "Artikel berhasil ditambahkan",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menambah artikel: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateArticle(String articleId) async {
    try {
      isLoading(true);

      await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .update({
            'title': articleTitle.value,
            'link': articleLink.value,
            'image': articleImage.value,
            'status': articleStatus.value,
            'updatedAt': DateTime.now().toIso8601String(),
          });

      // Reset form
      resetArticleForm();

      // Refresh data
      fetchArticles();

      Get.back();
      Get.snackbar(
        "Sukses",
        "Artikel berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memperbarui artikel: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteArticle(String articleId) async {
    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .delete();

      // Refresh data
      fetchArticles();

      Get.back();
      Get.snackbar(
        "Sukses",
        "Artikel berhasil dihapus",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menghapus artikel: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void prepareArticleForm(Map<String, dynamic> article) {
    articleTitle.value = article['title'];
    articleLink.value = article['link'] ?? '';
    articleImage.value = article['image'];
    articleStatus.value = article['status'];
  }

  void resetArticleForm() {
    articleTitle.value = '';
    articleLink.value = '';
    articleImage.value = '';
    articleStatus.value = true;
  }
}
