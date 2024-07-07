import 'package:flutter/material.dart';
import 'package:apotek_fe/models/obat.dart';
import 'package:apotek_fe/ui/home/screens/single_item_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ItemsWidget extends StatelessWidget {
  final List<Obat> obats;
  final Function() onObatUpdated;
  final bool scrollable;

  const ItemsWidget({
    Key? key,
    required this.obats,
    required this.onObatUpdated,
    this.scrollable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (obats.isEmpty) {
      return Center(
        child: Text(
          'Produk Tidak Tersedia',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: obats.length,
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) {
        final obat = obats[index];
        return _buildObatCard(context, obat);
      },
    );
  }

  Widget _buildObatCard(BuildContext context, Obat obat) {
    var url = dotenv.env['URL'];
    String imageUrl = obat.imageUrl.isNotEmpty ? '$url${obat.imageUrl[0]}' : '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleItemScreen(
                    obat,
                    onObatUpdated: onObatUpdated,
                  ),
                ),
              ).then((_) {
                onObatUpdated(); // Tambahkan ini
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey[400]);
                            },
                          )
                        : Icon(Icons.medication,
                            size: 40, color: Colors.grey[400]),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          obat.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          obat.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rp. ${obat.price.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
