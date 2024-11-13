import 'package:flutter/material.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringResources.nameApp,
          style: blackTextstyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Icon pertama
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Action untuk ikon pertama
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Action untuk ikon pertama
            },
          ),
          // Icon kedua
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Action untuk ikon kedua
            },
          ),
        ],
      ),
      body: const Text('Dashboard'),
    );
  }
}
