import 'package:apotek_fe/models/obat.dart';
import 'package:apotek_fe/ui/home/widgets/items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdukSearch extends StatefulWidget {
  final String query;
  final bool submit;
  final String isUser;
  final Function()? onObatUpdated;

  ProdukSearch(
      {required this.query,
      required this.submit,
      required this.isUser,
      this.onObatUpdated});
  @override
  State<ProdukSearch> createState() => _ProdukSearchState();
}

class _ProdukSearchState extends State<ProdukSearch> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  Future<List<Obat>> _getProductsSearch() async {
    final url = dotenv.env['URL'] ?? '';
    String api = '/api/search-obats?q=${widget.query}&userId=${widget.isUser}';

    final response = await http.get(Uri.parse('$url$api'));
    var jsonData = json.decode(response.body);

    List<Obat> obats = [];
    if (jsonData['success'] == true && jsonData['data'] is List) {
      for (var item in jsonData['data']) {
        obats.add(Obat.fromJson(item));
      }
    } else if (jsonData['success'] == true &&
        jsonData['data'] is Map<String, dynamic>) {
      // Jika hanya satu item dikembalikan
      obats.add(Obat.fromJson(jsonData['data']));
    }

    return obats;
  }

  void _handleObatUpdated() {
    // Panggil setState untuk memicu rebuild widget
    setState(() {});
    // Panggil callback dari parent jika ada
    widget.onObatUpdated?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Obat>>(
        future: _getProductsSearch(),
        builder: (BuildContext context, AsyncSnapshot<List<Obat>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada produk yang ditemukan'));
          } else {
            List<Obat> obats = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Hasil Pencarian untuk "${widget.query}"',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ItemsWidget(
                    obats: obats,
                    onObatUpdated: _handleObatUpdated,
                    scrollable: false,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
