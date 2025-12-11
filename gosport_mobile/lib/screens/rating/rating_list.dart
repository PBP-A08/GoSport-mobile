import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/rating.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:gosport_mobile/constants/urls.dart';
import 'package:provider/provider.dart';
import 'package:gosport_mobile/widgets/left_drawer.dart';
import 'package:gosport_mobile/screens/rating/rating_card.dart';

class RatingListPage extends StatefulWidget {
  const RatingListPage({super.key});

  @override
  State<RatingListPage> createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  Future<Rating> fetchRating(CookieRequest request) async {
    const baseUrl = 'http://localhost:8000/rating/rate-json/';
    final response = await request.get(baseUrl);

    // Convert json data to Rating objects
    final Rating ratings = Rating.fromJson(response);
    return ratings;
  }

  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      // jangan langsung kasih judul statis di AppBar
      appBar: AppBar(centerTitle: true),
      drawer: const LeftDrawer(),
      body: FutureBuilder<Rating>(
        future: fetchRating(request),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final rating = snapshot.data!;
            // update judul AppBar dengan nama produk
            return Scaffold(
              appBar: AppBar(
                title: Text("Review for ${rating.productName}"),
                centerTitle: true,
              ),
              body: rating.reviews.isEmpty
                  ? const Center(child: Text("Belum ada rating."))
                  : ListView.builder(
                      itemCount: rating.reviews.length,
                      itemBuilder: (_, index) => RatingCard(
                        rev: rating.reviews[index],
                        onTap: () {
                          if (rating.reviews[index].isOwner) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "You clicked on ${rating.productName}",
                                  ),
                                ),
                              );
                          } else {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Not your review"),
                                ),
                              );
                          }
                        },
                      ),
                    ),
            );
          }
        },
      ),
    );
  }
}
