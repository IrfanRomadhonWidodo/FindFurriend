// lib/views/admin/services/admin_services_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/admin/admin_services_controller.dart';

class AdminServicesView extends StatelessWidget {
  const AdminServicesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminServicesController controller = Get.put(
      AdminServicesController(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Kelola Artikel"),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchArticles(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.articles.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article, color: Colors.grey.shade400, size: 80),
                const SizedBox(height: 20),
                Text(
                  'Belum ada artikel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tekan tombol + untuk menambah artikel',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchArticles(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              final article = controller.articles[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article image
                      if (article['image'] != null &&
                          article['image'].toString().isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: article['image'],
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 180,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 180,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Article title
                      Text(
                        article['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Article link
                      if (article['link'] != null &&
                          article['link'].toString().isNotEmpty)
                        InkWell(
                          onTap: () {
                            // Launch URL
                            // You can use url_launcher package to open the link
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.link,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  article['link'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange,
                                    decoration: TextDecoration.underline,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Article date
                      Text(
                        DateFormat(
                          'dd MMM yyyy',
                        ).format(DateTime.parse(article['createdAt'])),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Status indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: article['status']
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              article['status'] ? 'Aktif' : 'Nonaktif',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: article['status']
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Edit button
                          IconButton(
                            onPressed: () {
                              controller.prepareArticleForm(article);
                              _showArticleForm(
                                context,
                                controller,
                                isEdit: true,
                                articleId: article['id'],
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            visualDensity: VisualDensity.compact,
                          ),

                          // Delete button
                          IconButton(
                            onPressed: () {
                              _showDeleteConfirmation(
                                context,
                                'Apakah Anda yakin ingin menghapus artikel ini?',
                                () => controller.deleteArticle(article['id']),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.resetArticleForm();
          _showArticleForm(context, controller, isEdit: false);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showArticleForm(
    BuildContext context,
    AdminServicesController controller, {
    required bool isEdit,
    String? articleId,
  }) {
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: Text(isEdit ? 'Edit Artikel' : 'Tambah Artikel'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: controller.articleTitle.value,
                  decoration: const InputDecoration(
                    labelText: 'Judul Artikel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul artikel tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) => controller.articleTitle.value = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.articleLink.value,
                  decoration: const InputDecoration(
                    labelText: 'Link Artikel',
                    border: OutlineInputBorder(),
                    hintText: 'https://example.com/artikel',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Link artikel tidak boleh kosong';
                    }
                    if (!value.startsWith('http')) {
                      return 'Link harus dimulai dengan http:// atau https://';
                    }
                    return null;
                  },
                  onChanged: (value) => controller.articleLink.value = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.articleImage.value,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar',
                    border: OutlineInputBorder(),
                    hintText: 'https://example.com/image.jpg',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URL gambar tidak boleh kosong';
                    }
                    if (!value.startsWith('http')) {
                      return 'URL harus dimulai dengan http:// atau https://';
                    }
                    return null;
                  },
                  onChanged: (value) => controller.articleImage.value = value,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => SwitchListTile(
                    title: const Text('Status Aktif'),
                    value: controller.articleStatus.value,
                    onChanged: (value) =>
                        controller.articleStatus.value = value,
                    activeColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (isEdit && articleId != null) {
                  controller.updateArticle(articleId);
                } else {
                  controller.addArticle();
                }
              }
            },
            child: Text(isEdit ? 'Update' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String message,
    VoidCallback onConfirm,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
