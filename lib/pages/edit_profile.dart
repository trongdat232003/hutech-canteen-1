import 'dart:convert';
import 'dart:io'; // To work with File
import 'package:flutter/material.dart';
import 'package:hutech_cateen/pages/login.dart';
import 'package:hutech_cateen/services/apiAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // To choose images
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ApiAuth apiAuth = ApiAuth();
  String? name;
  String? email;
  File? _image; // To hold the selected image file
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // For picking images
  String avatarUrl = ''; // To hold the avatar URL

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? metaDataString = prefs.getString('metaData');

    if (metaDataString != null) {
      print("User data found: $metaDataString");
      final responseData = jsonDecode(metaDataString);
      setState(() {
        name = responseData['user']['name'];
        email = responseData['user']['email'];
        _nameController.text = name ?? '';
        avatarUrl = responseData['user']['avatar'];
        print("helooooooooooooooooooooooo" + avatarUrl);
      });
    } else {
      print("No user data found in SharedPreferences.");
    }
  }

  // Handle saving user profile changes
  Future<void> _saveChanges() async {
    if (_nameController.text.isNotEmpty) {
      final snackBar = SnackBar(content: Text('Đang cập nhật thông tin'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      bool success = await apiAuth.editProfile(
        _nameController.text,
        _image,
      ); // Send both name and image

      if (success) {
        await _updateUserMetaData(); // Ensure this is awaited
        _showSnackBar('Cập nhật thông tin thành công');
        _navigateToLogin(); // Navigate to login page
      } else {
        _showSnackBar('Lỗi khi cập nhật thông tin');
      }
    } else {
      _showSnackBar('Name cannot be empty!');
    }
  }

  // Update local user metadata in SharedPreferences
  Future<void> _updateUserMetaData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? metaDataString = prefs.getString('metaData');

    if (metaDataString != null) {
      Map<String, dynamic> metaData = jsonDecode(metaDataString);
      metaData['user']['name'] = _nameController.text; // Update name
      metaData['user']['avatar'] = avatarUrl; // Update avatar URL
      prefs.setString('metaData', jsonEncode(metaData)); // Save updated data
    }
  }

  // Show a SnackBar for feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Navigate to login page
  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  // Pick an image from the gallery or camera
  void _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Save the selected image file
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chỉnh sửa thông tin cá nhân",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : avatarUrl.isNotEmpty
                                ? NetworkImage(
                                    avatarUrl) // Use NetworkImage for online images
                                : const AssetImage('images/user.jpg')
                                    as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () =>
                              _showImageSourceActionSheet(), // Show options for camera or gallery
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.orange,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Email: $email",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Họ và Tên",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: "Nhập họ và tên của bạn",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Lưu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show action sheet to choose image source
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn ảnh',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context); // Close the action sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context); // Close the action sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
