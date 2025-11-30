// lib/views/admin/services/admin_services_view.dart
import 'package:flutter/material.dart';

class AdminServicesView extends StatelessWidget {
  const AdminServicesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Kelola Layanan"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.miscellaneous_services, color: Colors.orange, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Halaman Layanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Kelola semua layanan yang tersedia',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
