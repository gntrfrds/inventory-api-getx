import 'package:flutter/material.dart';

import 'product_page.dart';

class DashboardPage
    extends StatelessWidget {
  const DashboardPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory Dashboard',
        ),
      ),

      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.dashboard,
                size: 80,
              ),

              const SizedBox(
                height: 20,
              ),

              const Text(
                'Inventory Dashboard',

                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Kelola data produk '
                'melalui REST API',
                textAlign:
                    TextAlign.center,
              ),

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width: 250,

                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            ProductPage(),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.inventory,
                  ),

                  label: const Text(
                    'Kelola Produk',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}