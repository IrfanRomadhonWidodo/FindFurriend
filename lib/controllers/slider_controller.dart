import 'package:get/get.dart';

class SliderController extends GetxController {
  var isLoading = true.obs;
  var imageUrls = <String>[].obs;

  @override
  void onInit() {
    fetchImages();
    super.onInit();
  }

  Future<void> fetchImages() async {
    try {
      // Menggunakan gambar lokal dari assets/slider
      List<String> allImages = [
        'assets/slider/slider1.jpg',
        'assets/slider/slider2.jpg',
        'assets/slider/slider3.jpg',
        'assets/slider/slider4.jpg',
      ];

      imageUrls.addAll(allImages);
    } catch (e) {
      print('Error fetching images: $e');

      // Fallback images
      imageUrls.addAll([
        'assets/slider/slider1.jpg',
        'assets/slider/slider2.jpg',
        'assets/slider/slider3.jpg',
        'assets/slider/slider4.jpg',
      ]);
    } finally {
      isLoading(false);
    }
  }
}
