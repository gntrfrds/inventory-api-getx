import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/product_controller.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final ProductController controller =
      Get.find<ProductController>();

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<File?> pickImage() async {
    final ImagePicker picker =
        ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (pickedFile == null) {
      return null;
    }

    return File(
      pickedFile.path,
    );
  }

  // ============================================================
  // DELETE DIALOG
  // ============================================================

  void showDeleteDialog(
    Product product,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Hapus Produk',
        ),

        content: Text(
          'Apakah Anda yakin ingin '
          'menghapus "${product.name}"?',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Batal',
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              Get.back();

              final success =
                  await controller.deleteProduct(
                product,
              );

              if (success) {
                Get.snackbar(
                  'Berhasil',
                  'Produk berhasil dihapus',
                  snackPosition:
                      SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  'Gagal',
                  controller.errorMessage.value,
                  snackPosition:
                      SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text(
              'Hapus',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT FORM
  // ============================================================

  void showProductForm({
    Product? product,
  }) {
    final bool isEdit =
        product != null;

    final nameController =
        TextEditingController(
      text: product?.name ?? '',
    );

    final priceController =
        TextEditingController(
      text: product?.price ?? '',
    );

    final categoryController =
        TextEditingController(
      text: product?.category ?? '',
    );

    final descriptionController =
        TextEditingController(
      text: product?.description ?? '',
    );

    final quantityController =
        TextEditingController(
      text: product?.quantity.toString() ??
          '1',
    );

    // Reactive state khusus dialog
    final Rx<File?> selectedImage =
        Rx<File?>(null);

    Get.dialog(
      AlertDialog(
        title: Text(
          isEdit
              ? 'Edit Produk'
              : 'Tambah Produk',
        ),

        content: SizedBox(
          width: 500,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                // FOTO
                Obx(
                  () => _buildImagePicker(
                    product: product,
                    selectedImage:
                        selectedImage.value,
                    onPickImage: () async {
                      final image =
                          await pickImage();

                      if (image != null) {
                        selectedImage.value =
                            image;
                      }
                    },
                    isEdit: isEdit,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // NAMA
                TextField(
                  controller:
                      nameController,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Nama Produk',

                    border:
                        OutlineInputBorder(),

                    prefixIcon: Icon(
                      Icons.inventory_2,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // HARGA
                TextField(
                  controller:
                      priceController,

                  keyboardType:
                      TextInputType.number,

                  decoration:
                      const InputDecoration(
                    labelText: 'Harga',

                    border:
                        OutlineInputBorder(),

                    prefixIcon: Icon(
                      Icons.payments,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // KATEGORI
                TextField(
                  controller:
                      categoryController,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Kategori',

                    border:
                        OutlineInputBorder(),

                    prefixIcon: Icon(
                      Icons.category,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // DESKRIPSI
                TextField(
                  controller:
                      descriptionController,

                  maxLines: 3,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Deskripsi',

                    border:
                        OutlineInputBorder(),

                    prefixIcon: Icon(
                      Icons.description,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // QUANTITY
                TextField(
                  controller:
                      quantityController,

                  keyboardType:
                      TextInputType.number,

                  decoration:
                      const InputDecoration(
                    labelText: 'Jumlah',

                    border:
                        OutlineInputBorder(),

                    prefixIcon: Icon(
                      Icons.numbers,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: const Text(
              'Batal',
            ),
          ),

          Obx(
            () => ElevatedButton.icon(
              onPressed:
                  controller.isSaving.value
                      ? null
                      : () async {
                          await saveProduct(
                            product: product,
                            name:
                                nameController
                                    .text
                                    .trim(),
                            price:
                                priceController
                                    .text
                                    .trim(),
                            category:
                                categoryController
                                    .text
                                    .trim(),
                            description:
                                descriptionController
                                    .text
                                    .trim(),
                            quantity:
                                int.tryParse(
                                  quantityController
                                      .text
                                      .trim(),
                                ) ??
                                    0,
                            image:
                                selectedImage
                                    .value,
                          );
                        },

              icon:
                  controller.isSaving.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.save,
                        ),

              label: Text(
                controller.isSaving.value
                    ? 'Menyimpan...'
                    : 'Simpan',
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ============================================================
  // SAVE PRODUCT
  // ============================================================

  Future<void> saveProduct({
    required Product? product,
    required String name,
    required String price,
    required String category,
    required String description,
    required int quantity,
    required File? image,
  }) async {
    if (name.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Nama produk wajib diisi',
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    if (price.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Harga produk wajib diisi',
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    bool success;

    // EDIT
    if (product != null) {
      success =
          await controller.updateProduct(
        product: product,
        name: name,
        price: price,
        category: category,
        description: description,
        quantity: quantity,
        image: image,
      );
    }

    // TAMBAH
    else {
      success =
          await controller.createProduct(
        name: name,
        price: price,
        category: category,
        description: description,
        quantity: quantity,
        image: image,
      );
    }

    if (success) {
      Get.back();

      Get.snackbar(
        'Berhasil',
        product != null
            ? 'Produk berhasil diperbarui'
            : 'Produk berhasil ditambahkan',
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Gagal',
        controller.errorMessage.value,
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // IMAGE PICKER WIDGET
  // ============================================================

  Widget _buildImagePicker({
    required Product? product,
    required File? selectedImage,
    required VoidCallback onPickImage,
    required bool isEdit,
  }) {
    Widget imageWidget;

    // Foto baru
    if (selectedImage != null) {
      imageWidget = Image.file(
        selectedImage,

        width: double.infinity,

        height: double.infinity,

        fit: BoxFit.cover,
      );
    }

    // Foto lama
    else if (product?.imageUrl != null &&
        product!.imageUrl!.isNotEmpty) {
      imageWidget = Image.network(
        'https://pos.cicd.web.id/assets/${product.imageUrl}',

        width: double.infinity,

        height: double.infinity,

        fit: BoxFit.cover,

        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress ==
              null) {
            return child;
          }

          return const Center(
            child:
                CircularProgressIndicator(),
          );
        },

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              size: 60,
            ),
          );
        },
      );
    }

    // Belum ada foto
    else {
      imageWidget = const Center(
        child: Icon(
          Icons.add_photo_alternate,
          size: 60,
        ),
      );
    }

    return Column(
      children: [
        // RESPONSIVE IMAGE
        AspectRatio(
          aspectRatio: 16 / 9,

          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(16),

            child: Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color:
                    Colors.grey.shade100,

                border: Border.all(
                  color:
                      Colors.grey.shade300,
                ),
              ),

              child: imageWidget,
            ),
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        // BUTTON FOTO
        SizedBox(
          width: double.infinity,

          child: OutlinedButton.icon(
            onPressed: onPickImage,

            icon: Icon(
              isEdit
                  ? Icons.photo_camera_back
                  : Icons
                      .add_photo_alternate,
            ),

            label: Text(
              isEdit
                  ? 'Ganti Foto'
                  : 'Pilih Foto',
            ),
          ),
        ),

        if (selectedImage != null)
          const Padding(
            padding:
                EdgeInsets.only(top: 6),

            child: Text(
              'Foto baru dipilih',

              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget buildProductCard(
    Product product,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      elevation: 3,

      clipBehavior:
          Clip.antiAlias,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // FOTO RESPONSIVE
          AspectRatio(
            aspectRatio: 16 / 9,

            child:
                product.imageUrl != null &&
                        product.imageUrl!
                            .isNotEmpty
                    ? Image.network(
                        'https://pos.cicd.web.id/assets/${product.imageUrl}',

                        width:
                            double.infinity,

                        fit: BoxFit.cover,

                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Container(
                            color: Colors
                                .grey
                                .shade200,

                            child:
                                const Center(
                              child: Icon(
                                Icons
                                    .broken_image,
                                size: 60,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors
                            .grey
                            .shade200,

                        child:
                            const Center(
                          child: Icon(
                            Icons
                                .image_not_supported,
                            size: 60,
                          ),
                        ),
                      ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  product.name,

                  style:
                      const TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Rp ${product.price}',

                  style:
                      const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                if (product.category !=
                    null)
                  Text(
                    'Kategori: '
                    '${product.category}',
                  ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  'Jumlah: '
                  '${product.quantity}',
                ),

                if (product.description !=
                        null &&
                    product.description!
                        .isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 8,
                    ),

                    child: Text(
                      product.description!,

                      maxLines: 3,

                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ),

                const SizedBox(
                  height: 12,
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,

                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        showProductForm(
                          product:
                              product,
                        );
                      },

                      icon: const Icon(
                        Icons.edit,
                      ),

                      label: const Text(
                        'Edit',
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        showDeleteDialog(
                          product,
                        );
                      },

                      icon: const Icon(
                        Icons.delete,
                      ),

                      label: const Text(
                        'Hapus',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory Produk',
        ),

        actions: [
          IconButton(
            onPressed:
                controller.loadProducts,

            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: Obx(
        () {
          // LOADING
          if (controller
              .isLoading.value) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // ERROR
          if (controller
              .errorMessage.value
              .isNotEmpty) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  24,
                ),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Text(
                      controller
                          .errorMessage.value,

                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    ElevatedButton.icon(
                      onPressed:
                          controller
                              .loadProducts,

                      icon: const Icon(
                        Icons.refresh,
                      ),

                      label: const Text(
                        'Coba Lagi',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // EMPTY
          if (controller
              .products.isEmpty) {
            return RefreshIndicator(
              onRefresh:
                  controller
                      .loadProducts,

              child: ListView(
                children: const [
                  SizedBox(
                    height: 200,
                  ),

                  Center(
                    child: Text(
                      'Belum ada produk',
                    ),
                  ),
                ],
              ),
            );
          }

          // PRODUCT LIST
          return RefreshIndicator(
            onRefresh:
                controller.loadProducts,

            child: ListView.builder(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              itemCount:
                  controller.products.length,

              itemBuilder:
                  (context, index) {
                final product =
                    controller.products[
                        index];

                return buildProductCard(
                  product,
                );
              },
            ),
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          showProductForm();
        },

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          'Tambah Produk',
        ),
      ),
    );
  }
}