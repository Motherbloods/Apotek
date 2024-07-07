import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final String fullname;
  final String email;
  final String imageUrl;

  EditProfilePage(
      {required this.email, required this.fullname, required this.imageUrl});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  String _userId = '';
  String _currentImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullname);
    _emailController = TextEditingController(text: widget.email);
    _currentImageUrl = widget.imageUrl;
    _loadUserId();
  }

  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Widget _buildProfileImage() {
    var url = dotenv.env['URL'];
    if (_imageFile != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: FileImage(_imageFile!),
      );
    } else if (_currentImageUrl.isNotEmpty) {
      if (_currentImageUrl.startsWith('https://res')) {
        return CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage('$_currentImageUrl'),
        );
      } else {
        return CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage('$url$_currentImageUrl'),
        );
      }
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage('assets/images/default.jpeg'),
      );
    }
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var url = dotenv.env['URL'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFF00BF62),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      _buildProfileImage(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF00BF62),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _updateProfile,
                  child: Text('Save Changes', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _updateProfile() async {
  //   if (_formKey.currentState!.validate()) {
  //     var url = dotenv.env['URL'];
  //     var urlparse = Uri.parse('$url/api/user/$_userId');

  //     try {
  //       final response = await http.put(
  //         urlparse,
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, String>{
  //           'email': _emailController.text,
  //           'fullname': _fullNameController.text,
  //           'imageurl': _currentImageUrl,
  //         }),
  //       );

  //       if (response.statusCode == 200) {
  //         final responseData = jsonDecode(response.body);
  //         if (responseData['success']) {
  //           await showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               Future.delayed(Duration(seconds: 1), () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //                 Navigator.of(context).pop(); // Return to profile page
  //               });

  //               return AlertDialog(
  //                 title: Text('Success'),
  //                 content: Text('Profile updated successfully'),
  //               );
  //             },
  //           );
  //         } else {
  //           throw Exception(responseData['message']);
  //         }
  //       } else {
  //         throw Exception('Failed to update profile');
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to update profile: $e')),
  //       );
  //     }
  //   }
  // }
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Updating profile..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
      var url = dotenv.env['URL'];
      var urlparse = Uri.parse('$url/api/user/$_userId');

      try {
        var request = http.MultipartRequest('PUT', urlparse);
        request.fields['email'] = _emailController.text;
        request.fields['fullname'] = _fullNameController.text;

        if (_imageFile != null) {
          request.files.add(
              await http.MultipartFile.fromPath('image', _imageFile!.path));
        } else if (_currentImageUrl.isNotEmpty) {
          request.fields['imageUrl'] = _currentImageUrl;
        }

        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        Navigator.of(context).pop();
        if (response.statusCode == 200) {
          if (jsonResponse['success']) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pop(true); // Return true to indicate update
                });

                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Profile updated successfully'),
                );
              },
            );
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception('Failed to update profile');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
