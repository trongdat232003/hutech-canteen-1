import 'package:flutter/material.dart';
import 'package:hutech_cateen/services/api_favorite.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart'; // Đảm bảo bạn có định nghĩa ColorWidget

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ApiFavorite apiFavorite = ApiFavorite();
  List<dynamic> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      var favorites = await apiFavorite.getFavorites();
      setState(() {
        favoriteProducts = favorites;
      });
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
      appBar: AppBar(
        title: Text(
          'Sản phẩm yêu thích',
          style: AppWidget.boldTextMediumFieldStyle(),
        ),
        iconTheme: IconThemeData(color: ColorWidget.primaryColor()),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 2,
            color: ColorWidget.primaryColor(), // Màu của border
          ),
          const SizedBox(
              height: 10), // Khoảng cách 20px giữa AppBar và danh sách
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: favoriteProducts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: favoriteProducts.length,
                      itemBuilder: (context, index) {
                        var product = favoriteProducts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: Image.asset(
                              product['product_thumb'],
                              fit: BoxFit.cover,
                              width: 80,
                            ),
                            title: Text(
                              product['product_name'],
                              style: AppWidget.boldTextMediumFieldStyle(),
                            ),
                            subtitle: Text(
                              '${Helpers.formatPrice(product['product_price'])} ',
                              style: AppWidget.descripe(),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Thêm hành động khi nhấn nút
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(2),
                                backgroundColor: ColorWidget.primaryColor(),
                                foregroundColor: ColorWidget.primaryColor(),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
