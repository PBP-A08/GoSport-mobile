import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/rating.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:provider/provider.dart';
import 'package:gosport_mobile/widgets/left_drawer.dart';
import 'package:gosport_mobile/screens/rating/rating_card.dart';

class RatingListPage extends StatefulWidget {
  final String productId;
  final String productName;
  const RatingListPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<RatingListPage> createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  Future<Rating> fetchRating(CookieRequest request) async {
    final baseUrl = Urls.ratingJson;
    final response = await request.get("$baseUrl${widget.productId}");

    // Convert json data to Rating objects
    final Rating ratings = Rating.fromJson(response);
    return ratings;
  }

  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Review for ${widget.productName}"),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: FutureBuilder<Rating>(
        future: fetchRating(request),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final rating = snapshot.data!;
            return Scaffold(
              body: rating.reviews.isEmpty
                  ? const Center(child: Text("There's no review for this product.",
                  style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),))
                  : ListView.builder(
                      itemCount: rating.reviews.length,
                      itemBuilder: (_, index) =>
                          RatingCard(rev: rating.reviews[index]),
                    ),
            );
          }
        },
      ),
    );
  }
}
