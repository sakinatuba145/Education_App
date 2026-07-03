import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String university;
  final String bio;
  final XFile? image;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.university,
    required this.bio,
    this.image,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController universityController;

  XFile? selectedImage;
  final ImagePicker picker = ImagePicker();

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    bioController = TextEditingController(text: widget.bio);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    universityController = TextEditingController(text: widget.university);
    selectedImage = widget.image;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  Widget _animate(int index, Widget child) {
    final start = (index * 0.08).clamp(0.0, 0.75);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.12),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }




  void saveProfile() {
    Navigator.pop(context, {
      "name": nameController.text,
      "bio": bioController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "university": universityController.text,
      "image": selectedImage,
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    bioController.dispose();
    emailController.dispose();
    phoneController.dispose();
    universityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: _animate(
          0,
          Text(
            "Edit Profile",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _animate(
              1,
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primary, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 56,
                              backgroundColor: primary.withValues(alpha: 0.15),
                              backgroundImage: selectedImage != null
                                  ? FileImage(File(selectedImage!.path))
                                  : null,
                              child: selectedImage == null
                                  ? Icon(
                                Icons.person,
                                size: 64,
                                color: primary,
                              )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: InkWell(
                              onTap: showImageOptions,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: primary,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Update your profile photo",
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text("Member since 2026", style: textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            _animate(
              2,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Personal Information",
                  style: textTheme.headlineMedium,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _animate(
              3,
              _profileField(
                context,
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
              ),
            ),
            const SizedBox(height: 15),

            _animate(
              4,
              _profileField(
                context,
                controller: bioController,
                label: "Bio / Role",
                icon: Icons.badge,
              ),
            ),
            const SizedBox(height: 15),

            _animate(
              5,
              _profileField(
                context,
                controller: emailController,
                label: "Email",
                icon: Icons.email,
              ),
            ),
            const SizedBox(height: 15),

            _animate(
              6,
              _profileField(
                context,
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone,
              ),
            ),
            const SizedBox(height: 15),

            _animate(
              7,
              _profileField(
                context,
                controller: universityController,
                label: "University",
                icon: Icons.school,
              ),
            ),

            const SizedBox(height: 25),

            _animate(
              8,
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: saveProfile,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _profileField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required IconData icon,
      }) {
    final primary = Theme.of(context).colorScheme.primary;

    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primary),
      ),
    );
  }
}