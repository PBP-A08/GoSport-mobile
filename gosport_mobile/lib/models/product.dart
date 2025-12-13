// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String model;
    String pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    dynamic seller;
    String productName;
    String oldPrice;
    String specialPrice;
    int discountPercent;
    String category;
    String description;
    String thumbnail;
    int stock;
    DateTime createdAt;
    DateTime updatedAt;
    double avgRating;

    Fields({
        required this.seller,
        required this.productName,
        required this.oldPrice,
        required this.specialPrice,
        required this.discountPercent,
        required this.category,
        required this.description,
        required this.thumbnail,
        required this.stock,
        required this.createdAt,
        required this.updatedAt,
        required this.avgRating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        seller: json["seller"],
        productName: json["product_name"],
        oldPrice: json["old_price"],
        specialPrice: json["special_price"],
        discountPercent: json["discount_percent"],
        category: json["category"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        stock: json["stock"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        avgRating: json["avg_rating"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "seller": seller,
        "product_name": productName,
        "old_price": oldPrice,
        "special_price": specialPrice,
        "discount_percent": discountPercent,
        "category": category,
        "description": description,
        "thumbnail": thumbnail,
        "stock": stock,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "avg_rating": avgRating,
    };
}
