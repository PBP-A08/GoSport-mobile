import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gosport_mobile/constants/urls.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _addressController;
  late TextEditingController _storeNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.profile['username'],
    );
    _addressController = TextEditingController(
      text: widget.profile['address'] == '-' ? '' : widget.profile['address'],
    );
    _storeNameController = TextEditingController(
      text: widget.profile['store_name'] == '-'
          ? ''
          : widget.profile['store_name'],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _addressController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = context.read<CookieRequest>();

    try {
      final data = {'username': _usernameController.text};

      if (widget.profile['role'] == 'buyer') {
        data['address'] = _addressController.text;
      } else if (widget.profile['role'] == 'seller') {
        data['store_name'] = _storeNameController.text;
      }

      final response = await request.postJson(
        Urls.profileEdit,
        jsonEncode(data),
      );

      if (!mounted) return;

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(response['error'] ?? 'Failed to update profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              if (widget.profile['role'] == 'buyer')
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  maxLines: 3,
                ),

              if (widget.profile['role'] == 'seller')
                TextFormField(
                  controller: _storeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Store Name',
                    prefixIcon: Icon(Icons.store_outlined),
                  ),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
