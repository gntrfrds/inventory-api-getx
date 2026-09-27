import 'dart:io';

import 'package:get/get.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  // ============================================================
  // SERVICE
  // ============================================================

  final ApiService apiService =
      ApiService();

  // ============================================================
  // REACTIVE STATE
  // ============================================================

  final RxList<Product> products =
      <Product>[].obs;

  final RxBool isLoading =
      false.obs;

  final RxBool isSaving =
      false.obs;

  final RxBool isDeleting =
      false.obs;

  final RxString errorMessage =
      ''.obs;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadProducts();
  }

  // ============================================================
  // GET PRODUCTS
  // ============================================================

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;

      errorMessage.value = '';

      final result =
          await apiService.getProducts();

      products.assignAll(result);
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  Future<bool> createProduct({
    required String name,
    required String price,
    required String category,
    required String description,
    required int quantity,
    File? image,
  }) async {
    try {
      isSaving.value = true;

      String? imageId;

      // Upload foto jika user memilih foto
      if (image != null) {
        imageId =
            await apiService.uploadImage(
          image,
        );
      }

      await apiService.createProduct(
        name: name,
        price: price,
        category: category,
        description: description,
        quantity: quantity,
        imageUrl: imageId,
      );

      // Ambil data terbaru
      await loadProducts();

      return true;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<bool> updateProduct({
    required Product product,
    required String name,
    required String price,
    required String category,
    required String description,
    required int quantity,
    File? image,
  }) async {
    try {
      isSaving.value = true;

      // Jika tidak mengganti foto,
      // gunakan foto lama.
      String? imageId =
          product.imageUrl;

      // Jika memilih foto baru,
      // upload foto baru.
      if (image != null) {
        imageId =
            await apiService.uploadImage(
          image,
        );
      }

      await apiService.updateProduct(
        id: product.id,
        name: name,
        price: price,
        category: category,
        description: description,
        quantity: quantity,
        imageUrl: imageId,
      );

      // Ambil data terbaru
      await loadProducts();

      return true;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<bool> deleteProduct(
    Product product,
  ) async {
    try {
      isDeleting.value = true;

      await apiService.deleteProduct(
        product.id,
      );

      products.removeWhere(
        (item) => item.id == product.id,
      );

      return true;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    errorMessage.value = '';
  }
}