import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/product_controller.dart';
import 'pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register ProductController
  Get.put(
    ProductController(),
  );

  runApp(
    const InventoryApp(),
  );
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GetMaterialApp(
      debugShowCheckedModeBanner:
          false,

      title: 'Inventory API App',

      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        useMaterial3: true,
      ),

      home: const LoginPage(),
    );
  }
}