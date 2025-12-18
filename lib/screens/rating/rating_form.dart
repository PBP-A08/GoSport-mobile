import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gosport_mobile/widgets/left_drawer.dart';
import 'package:gosport_mobile/constants/urls.dart';

class RatingFormPage extends StatefulWidget {
  final String productId;
  final String productName;
  const RatingFormPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<RatingFormPage> createState() => _RatingFormPageState();
}

class _RatingFormPageState extends State<RatingFormPage> {
  final _formKey = GlobalKey<FormState>();
  // Updated variables to match Product model
  String _review = "";
  int _rate = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Rate ${widget.productName}')),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rate ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _rate = index + 1; // rating mulai dari 1
                        });
                      },
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Tell us your experienced",
                    labelText: "Review",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _review = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Review cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red[700]),
                    ),
                    onPressed: () async {
                      if (context.mounted) {
                        if (_rate == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Pick a star")),
                          );
                        } else {
                          if (_formKey.currentState!.validate()) {
                            final response = await request.postJson(
                              "${Urls.baseUrl}/rating/add-review-flutter/${widget.productId}",
                              jsonEncode(<String, String>{
                                'rate': _rate.toString(),
                                'review': _review,
                              }),
                            );
                            if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Thank you for the review"),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to save your review."),
                              ),
                            );
                          }
                          }
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
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
