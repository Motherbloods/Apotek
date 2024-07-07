import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:apotek_fe/models/obat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditObatScreen extends StatefulWidget {
  final Obat item;

  EditObatScreen({Key? key, required this.item}) : super(key: key);

  @override
  _EditObatScreenState createState() => _EditObatScreenState();
}

class _EditObatScreenState extends State<EditObatScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;
  final List<String> categories = ['Obat Pilek', 'Obat Panas', 'Obat Batuk'];

// Define the selected category variable
  String? selectedCategory;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    selectedCategory = widget.item.category;
    _priceController =
        TextEditingController(text: widget.item.price.toString());
    _stockController =
        TextEditingController(text: widget.item.stock.toString());
    _descriptionController =
        TextEditingController(text: widget.item.description);
    _images = List.from(widget.item.imageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _images.add(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      // Tambahkan dialog atau snackbar untuk menampilkan error ke user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // Future<void> updateObats() async {
  //   final url = '${dotenv.env['URL']}/api/update-obat/${widget.item.id}';

  //   final headers = {'Content-Type': 'application/json'};
  //   print('ini jimages $_images');
  //   final body = json.encode({
  //     'name': _nameController.text,
  //     'category': selectedCategory!,
  //     'price': double.parse(_priceController.text),
  //     'stock': int.parse(_stockController.text),
  //     'desc': _descriptionController.text,
  //     'imageUrl': _images,
  //   });

  //   try {
  //     final response =
  //         await http.put(Uri.parse(url), headers: headers, body: body);
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Medicine updated successfully'),
  //           // Tambahkan key untuk memastikan uniqueness
  //           key: UniqueKey(),
  //         ),
  //       );
  //       final updatedObat = Obat(
  //         id: widget.item.id,
  //         name: _nameController.text,
  //         category: selectedCategory!,
  //         price: double.parse(_priceController.text),
  //         stock: int.parse(_stockController.text),
  //         description: _descriptionController.text,
  //         imageUrl: _images,
  //       );
  //       Navigator.pop(context, updatedObat);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to update medicine')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  Future<void> updateObats() async {
    final url = '${dotenv.env['URL']}/api/update-obat/${widget.item.id}';

    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      request.fields['name'] = _nameController.text;
      request.fields['category'] = selectedCategory!;
      request.fields['price'] = _priceController.text;
      request.fields['stock'] = _stockController.text;
      request.fields['desc'] = _descriptionController.text;

      // Only send existing image URLs
      List<String> existingImages =
          _images.where((image) => image.startsWith('/images')).toList();
      print(existingImages);
      request.fields['imageUrl'] = jsonEncode(_images);

      // Add new image files
      for (var image
          in _images.where((image) => !image.startsWith('/images'))) {
        var file = await http.MultipartFile.fromPath('images', image);
        request.files.add(file);
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Medicine updated successfully'),
            key: UniqueKey(),
          ),
        );

        // Use the updated image URLs from the server response
        List<String> updatedImageUrls =
            List<String>.from(jsonResponse['obat']['imageUrl']);

        final updatedObat = Obat(
          id: widget.item.id,
          name: _nameController.text,
          category: selectedCategory!,
          price: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          description: _descriptionController.text,
          imageUrl: updatedImageUrls,
        );
        Navigator.pop(context, updatedObat);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update medicine: ${jsonResponse['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildImageWidget(String imagePath) {
    var url = dotenv.env['URL'];
    if (imagePath.startsWith('/images')) {
      // Gambar dari network
      return Image.network(
        '$url$imagePath',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      // Gambar lokal
      return Image.file(
        File(imagePath),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Obat'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(labelText: 'Category'),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            Text('Images:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length + 1,
                itemBuilder: (context, index) {
                  if (index == _images.length) {
                    return GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        color: Colors.grey[300],
                        child: Icon(Icons.add_photo_alternate, size: 40),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      _buildImageWidget(_images[index]),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            color: Colors.red,
                            child: Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: updateObats,
                child: Text('Save Changes'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
