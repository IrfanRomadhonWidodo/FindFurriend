import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findfurriend/controllers/slider_controller.dart';
import 'package:findfurriend/views/slider_view.dart';

void main() {
  Get.put(SliderController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FindFurriend',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SliderView()),
        // Add other routes here
      ],
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFF9C4),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
