import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notizen/features/baby-profile/widgets/profile_picture_widget.dart';
import 'package:notizen/features/user-profile/controller/user_controller.dart';
import 'package:notizen/models/user_model.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final genderOptions = ['Male', 'Female', 'Other'];
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String _selectedGender = 'Male';
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userControllerProvider).value;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _selectedGender = user?.gender ?? 'Male';
    _base64Image = user?.photo;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userControllerProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => GoRouter.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
            size: 20,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (user) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: ProfilePictureWidget(
                      profileImageUrl: 'assets/images/baby-default.png',
                      svgIconUrl: 'assets/images/image-upload.svg',
                      base64Img: _base64Image ?? '',
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(_nameController, 'Full Name'),
                  const SizedBox(height: 16),
                  _buildTextField(_emailController, 'Email', enabled: false),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _phoneController,
                    'Phone Number',
                    required: false,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value:
                        genderOptions.contains(_selectedGender)
                            ? _selectedGender
                            : null,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGender = value;
                        });
                      }
                    },
                    items:
                        genderOptions.map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(
                              gender,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    dropdownColor: const Color(0xE6443B83),
                    decoration: _inputDecoration('Gender'),
                  ),

                  const SizedBox(height: 30),
                  CustomButtonWidget(
                    text: "Save Profile",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedUser = UserModel(
                          uid: user!.uid,
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          phone: _phoneController.text.trim(),
                          gender: _selectedGender,
                          photo: _base64Image,
                        );
                        ref
                            .read(userControllerProvider.notifier)
                            .updateUser(updatedUser);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated')),
                        );
                        GoRouter.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  TextFormField _buildTextField(
    TextEditingController controller,
    String label, {
    bool enabled = true,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.white : const Color(0X80FFFFFF),
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
      decoration: _inputDecoration(label),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Required';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: "Poppins",
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Colors.white),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0X80FFFFFF)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 22),
    );
  }
}
