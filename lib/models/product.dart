class Product {
  final String id;
  final String? status;
  final int? sort;
  final String? userCreated;
  final String? dateCreated;
  final String? userUpdated;
  final String? dateUpdated;

  final String name;
  final String price;
  final String? imageUrl;
  final String? category;
  final String? description;
  final int quantity;

  Product({
    required this.id,
    this.status,
    this.sort,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    required this.name,
    required this.price,
    this.imageUrl,
    this.category,
    this.description,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString(),

      sort: json['sort'] == null
          ? null
          : int.tryParse(
              json['sort'].toString(),
            ),

      userCreated: json['user_created']?.toString(),

      dateCreated: json['date_created']?.toString(),

      userUpdated: json['user_updated']?.toString(),

      dateUpdated: json['date_updated']?.toString(),

      name: json['name']?.toString() ?? '',

      price: json['price']?.toString() ?? '0',

      imageUrl: json['image_url']?.toString(),

      category: json['category']?.toString(),

      description: json['description']?.toString(),

      quantity: int.tryParse(
            json['quantity']?.toString() ?? '0',
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'description': description,
      'quantity': quantity,
      'status': status,
      'sort': sort,
    };
  }
}