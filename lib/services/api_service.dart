import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../models/product.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://pos.cicd.web.id',

      connectTimeout: const Duration(
        seconds: 15,
      ),

      receiveTimeout: const Duration(
        seconds: 15,
      ),

      sendTimeout: const Duration(
        seconds: 15,
      ),

      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // ============================================================
  // GET PRODUCTS
  // ============================================================

  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get(
        '/items/products',
      );

      dynamic data = response.data;

      // Jika response berupa String
      if (data is String) {
        data = jsonDecode(data);
      }

      // Format:
      // {
      //   "data": [...]
      // }

      if (data is Map &&
          data['data'] is List) {
        final List products = data['data'];

        return products
            .map(
              (json) => Product.fromJson(
                Map<String, dynamic>.from(
                  json,
                ),
              ),
            )
            .toList();
      }

      // Jika API langsung mengembalikan List
      if (data is List) {
        return data
            .map(
              (json) => Product.fromJson(
                Map<String, dynamic>.from(
                  json,
                ),
              ),
            )
            .toList();
      }

      throw Exception(
        'Format data API tidak sesuai.\n'
        'Tipe response: ${data.runtimeType}',
      );
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
      );
    }
  }

  // ============================================================
  // UPLOAD IMAGE
  // ============================================================

  Future<String> uploadImage(
    File imageFile,
  ) async {
    try {
      final fileName =
          imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        '/files',

        data: formData,

        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map &&
          data['data'] is Map) {
        final uploadedFile =
            Map<String, dynamic>.from(
          data['data'],
        );

        final imageId =
            uploadedFile['id'];

        if (imageId != null) {
          return imageId.toString();
        }
      }

      throw Exception(
        'Upload foto gagal.',
      );
    } on DioException catch (e) {
      throw Exception(
        'Gagal upload foto: '
        '${_getErrorMessage(e)}',
      );
    }
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  Future<Product> createProduct({
    required String name,
    required String price,
    required String category,
    required String description,
    required int quantity,
    String? imageUrl,
  }) async {
    try {
      final response = await dio.post(
        '/items/products',

        data: {
          'name': name,
          'price': price,
          'category': category,
          'description': description,
          'quantity': quantity,
          'image_url': imageUrl,
        },
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map &&
          data['data'] is Map) {
        return Product.fromJson(
          Map<String, dynamic>.from(
            data['data'],
          ),
        );
      }

      if (data is Map) {
        return Product.fromJson(
          Map<String, dynamic>.from(
            data,
          ),
        );
      }

      throw Exception(
        'Response POST tidak sesuai',
      );
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    }
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<Product> updateProduct({
    required String id,
    required String name,
    required String price,
    required String category,
    required String description,
    required int quantity,
    String? imageUrl,
  }) async {
    try {
      final response = await dio.patch(
        '/items/products/$id',

        data: {
          'name': name,
          'price': price,
          'category': category,
          'description': description,
          'quantity': quantity,
          'image_url': imageUrl,
        },
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map &&
          data['data'] is Map) {
        return Product.fromJson(
          Map<String, dynamic>.from(
            data['data'],
          ),
        );
      }

      if (data is Map) {
        return Product.fromJson(
          Map<String, dynamic>.from(
            data,
          ),
        );
      }

      throw Exception(
        'Response PATCH tidak sesuai',
      );
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<void> deleteProduct(
    String id,
  ) async {
    try {
      await dio.delete(
        '/items/products/$id',
      );
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    }
  }

  // ============================================================
  // ERROR HANDLER
  // ============================================================

  String _getErrorMessage(
    DioException e,
  ) {
    if (e.response != null) {
      final statusCode =
          e.response?.statusCode;

      switch (statusCode) {
        case 400:
          return '400 - Bad Request';

        case 401:
          return '401 - Unauthorized';

        case 403:
          return '403 - Forbidden';

        case 404:
          return '404 - Data tidak ditemukan';

        case 413:
          return '413 - Ukuran foto terlalu besar';

        case 500:
          return '500 - Server Error';

        default:
          return 'Error HTTP $statusCode';
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Koneksi ke server timeout';

      case DioExceptionType.sendTimeout:
        return 'Pengiriman data timeout';

      case DioExceptionType.receiveTimeout:
        return 'Server terlalu lama memberikan response';

      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server';

      case DioExceptionType.badResponse:
        return 'Response server tidak valid';

      default:
        return e.message ??
            'Terjadi kesalahan';
    }
  }
}