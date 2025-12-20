// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';

Rating ratingFromJson(String str) => Rating.fromJson(json.decode(str));

String ratingToJson(Rating data) => json.encode(data.toJson());

class Rating {
    String productName;
    String id;
    List<Review> reviews;

    Rating({
        required this.productName,
        required this.id,
        required this.reviews,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        productName: json["product_name"],
        id: json["id"],
        reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "product_name": productName,
        "id": id,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
    };
}

class Review {
    String user;
    int rating;
    String review;
    bool isOwner;

    Review({
        required this.user,
        required this.rating,
        required this.review,
        required this.isOwner,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        user: json["user"],
        rating: json["rating"],
        review: json["review"],
        isOwner: json["is_owner"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "rating": rating,
        "review": review,
        "is_owner": isOwner,
    };
}
