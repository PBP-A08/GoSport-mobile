import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/rating.dart';
import 'package:gosport_mobile/screens/rating/rating_form.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RatingCard extends StatelessWidget {
  final Rating rate;
  final Review rev;

  const RatingCard({super.key, required this.rev, required this.rate});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  rev.user,
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    rev.rating, // total bintang
                    (index) => Icon(Icons.star, color: Colors.amber, size: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  rev.review,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (rev.isOwner)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                  "Are you sure you want to Delete your Review?",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      final response = await request.post(
                                        "${Urls.baseUrl}/rating/delete-review-flutter/${rate.id}",
                                        {},
                                      );
                                      if (context.mounted) {
                                        if (response['status'] == 'success') {
                                          ScaffoldMessenger.of(context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Review successfully deleted",
                                                ),
                                              ),
                                            );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Failed to delete your review."),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RatingFormPage(
                                productId: rate.id,
                                productName: rate.productName,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.yellow[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
