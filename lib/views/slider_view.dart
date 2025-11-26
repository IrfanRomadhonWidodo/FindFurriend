import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        'emoji': '🛁',
        'description':
            'Perawatan profesional untuk membuat hewan peliharaan Anda tampil memukau dan sehat',
      },
      {
        'title': 'Boarding',
        'emoji': '🏨',
        'description':
            'Tempat istirahat nyaman dengan pemantauan 24 jam saat Anda sedang berlibur',
      },
      {
        'title': 'Day Care',
        'emoji': '🎮',
        'description':
            'Ruang bermain yang aman untuk hewan peliharaan bersosialisasi dan berolahraga',
      },
      {
        'title': 'Training',
        'emoji': '🎓',
        'description':
            'Program latihan terstruktur dengan metode modern untuk mengendalikan perilaku',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Slider dengan auto-swipe
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

                // Setup auto-swipe timer
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
                    // Indicator dots dengan animasi
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

            // Modern Start Button - Mengarah ke login
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

// Widget untuk service card - Gambar persegi panjang dengan deskripsi di bawah
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
            // Gambar horizontal dengan AspectRatio tapi dibatasi tingginya
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 180, // Kurangi tinggi agar pas di HP 6.5 inch
              ),
              child: AspectRatio(
                aspectRatio:
                    4 / 3, // Horizontal (lebar lebih besar dari tinggi)
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.orange.shade50,
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.orange.shade100,
                          child: const Center(
                            child: Icon(
                              Icons.pets,
                              size: 100,
                              color: Colors.orange,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Deskripsi di bawah
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title']!,
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
