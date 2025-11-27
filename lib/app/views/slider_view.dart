import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../controllers/slider_controller.dart';

class SliderView extends GetView<SliderController> {
  const SliderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final RxInt currentIndex = 0.obs;
    Timer? autoSwipeTimer;

    // Data layanan petshop
    final services = [
      {
        'title': 'Grooming',
        'description':
            'Perawatan profesional untuk membuat hewan peliharaan Anda tampil memukau dan sehat',
      },
      {
        'title': 'Boarding',
        'description':
            'Tempat istirahat nyaman dengan pemantauan 24 jam saat Anda sedang berlibur',
      },
      {
        'title': 'Day Care',
        'description':
            'Ruang bermain yang aman untuk hewan peliharaan bersosialisasi dan berolahraga',
      },
      {
        'title': 'Training',
        'description':
            'Program latihan terstruktur dengan metode modern untuk mengendalikan perilaku',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.orange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'FindFurriend',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Slider
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      strokeWidth: 3,
                    ),
                  );
                }

                // Auto-swipe timer
                if (controller.imageUrls.isNotEmpty) {
                  autoSwipeTimer?.cancel();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    autoSwipeTimer = Timer.periodic(
                      const Duration(seconds: 4),
                      (timer) {
                        if (pageController.hasClients) {
                          currentIndex.value =
                              (currentIndex.value + 1) %
                              controller.imageUrls.length;
                          pageController.animateToPage(
                            currentIndex.value,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    );
                  });
                }

                return Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) {
                          currentIndex.value = index;
                        },
                        itemCount: controller.imageUrls.length,
                        itemBuilder: (context, index) {
                          return ServiceCard(
                            imageUrl: controller.imageUrls[index],
                            service: services[index % services.length],
                            index: index + 1,
                            totalPages: controller.imageUrls.length,
                          );
                        },
                      ),
                    ),
                    // Indicator dots
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(controller.imageUrls.length, (
                          index,
                        ) {
                          return Obx(
                            () => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: currentIndex.value == index ? 10 : 8,
                              width: currentIndex.value == index ? 30 : 8,
                              decoration: BoxDecoration(
                                color: currentIndex.value == index
                                    ? Colors.orange
                                    : Colors.orange.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              }),
            ),

            // Start button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      autoSwipeTimer?.cancel();
                      Get.toNamed('/login');
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Mulai Sekarang',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ServiceCard widget responsif
class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final Map<String, String> service;
  final int index;
  final int totalPages;

  const ServiceCard({
    Key? key,
    required this.imageUrl,
    required this.service,
    required this.index,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Gambar responsif
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = width * 0.6; // ratio horizontal 5:3

                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: width,
                    height: height,
                    fit: BoxFit
                        .cover, // bisa BoxFit.contain kalau tidak mau crop
                    placeholder: (context, url) => Container(
                      color: Colors.orange.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.orange.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.pets,
                          size: 100,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Deskripsi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${service['emoji'] ?? ''} ${service['title']!}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  service['description']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
