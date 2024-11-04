import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/CategoryItem.dart';
import 'package:hutech_cateen/Components/ProductItem.dart';
import 'package:hutech_cateen/Components/_search.dart';
import 'package:hutech_cateen/Components/info_user.dart';
import 'package:hutech_cateen/Components/product_grid.dart';
import 'package:hutech_cateen/Components/row_title.dart';
import 'package:hutech_cateen/pages/edit_profile.dart';
import 'package:hutech_cateen/services/apiCategory.dart';
import 'package:hutech_cateen/services/apiProduct.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categoriesImage = [
    "images/drink.png",
    "images/candies.png",
    "images/morning-coffee.png",
    "images/sunsets.png"
  ];
  List categories = [];
  List products = [];
  List lastProducts = [];
  List productsByRating = [];
  String userName = '';
  String avatarUrl = '';
  bool isLoadingCategories = true;
  bool isLoadingProducts = true;
  bool isLoadingLastProducts = true;
  bool isLoadingProductsByRating = true;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchCategoriesFromApi();
    fetchProductsFromApi();
    fetchLastProductFromApi();
    fetchProductsByRatingFromApi();
  }

  void fetchCategoriesFromApi() async {
    try {
      ApiCategoryService apiService = ApiCategoryService();
      List<dynamic> fetchedCategories = await apiService.getCategories();

      setState(() {
        categories = fetchedCategories
            .map((category) => {
                  'meal': category['meals'],
                  'id': category['_id'],
                })
            .toList();
        isLoadingCategories = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  void fetchLastProductFromApi() async {
    try {
      ApiProduct apiService = ApiProduct();
      List<dynamic> fetchedLastProducts = await apiService.getLastProducts();

      setState(() {
        lastProducts = fetchedLastProducts
            .map((product) => {
                  'productName': product['product_name'],
                  'productID': product['_id'],
                  'productThumb': product['product_thumb'],
                  'productPrice': product['product_price'].toString(),
                })
            .toList();
        isLoadingLastProducts = false;
      });
    } catch (e) {
      print('Error fetching last products: $e');
      setState(() {
        isLoadingLastProducts = false;
      });
    }
  }

  void fetchProductsByRatingFromApi() async {
    try {
      ApiProduct apiService = ApiProduct();
      List<dynamic> fetchedProductsByRating =
          await apiService.getProductsSortedByRating();

      setState(() {
        productsByRating = fetchedProductsByRating
            .map((product) => {
                  'productName': product['product_name'],
                  'productID': product['_id'],
                  'productThumb': product['product_thumb'],
                  'productPrice': product['product_price'].toString(),
                })
            .toList();
        isLoadingProductsByRating = false;
      });
    } catch (e) {
      print('Error fetching products by rating: $e');
      setState(() {
        isLoadingProductsByRating = false;
      });
    }
  }

  void fetchProductsFromApi() async {
    try {
      ApiProduct apiService = ApiProduct();
      List<dynamic> fetchedProducts = await apiService.getProducts();

      setState(() {
        products = fetchedProducts
            .map((product) => {
                  'productName': product['product_name'],
                  'productID': product['_id'],
                  'productThumb': product['product_thumb'],
                  'productPrice': product['product_price'].toString(),
                })
            .toList();
        isLoadingProducts = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoadingProducts = false;
      });
    }
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve the token

    if (token != null) {
      try {
        // Make the API call to get user info
        final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/v2/api/user/getUserInfo'),
          headers: {
            'Authorization': '$token', // Include the access token
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 200) {
            var user = responseData['metaData'];
            // Update user info in state
            setState(() {
              userName = user['name'];
              avatarUrl = user['avatar'];
            });
          } else {
            print("Error: ${responseData['message']}");
          }
        } else {
          print(
              "Failed to load user data, status code: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("No token found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoUser(
                userName: userName,
                avatarUrl: avatarUrl.isNotEmpty ? avatarUrl : 'images/user.jpg',
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Container(
                    height: 70,
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorWidget.primaryColor(),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(12, 10),
                        ),
                      ],
                    ),
                    width: 118,
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image(image: AssetImage('images/food.png')),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tất cả',
                          style: AppWidget.boldTextSmallFieldStyle(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 80,
                      child: (categories.isNotEmpty)
                          ? ListView.builder(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              itemCount: categoriesImage.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return CategoryItem(
                                  image: categoriesImage[index],
                                  title: categories[index]['meal'],
                                  categoryID: categories[index]['id'],
                                );
                              })
                          : const Center(child: Text("Không có danh mục nào")),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoadingProductsByRating
                  ? Center(child: CircularProgressIndicator())
                  : ProductGrid(
                      title: 'Sản phẩm được đánh giá cao',
                      products: productsByRating,
                    ),
              const SizedBox(height: 20),
              isLoadingLastProducts
                  ? Center(child: CircularProgressIndicator())
                  : ProductGrid(
                      title: 'Sản phẩm mới nhất',
                      products: lastProducts,
                    ),
              const SizedBox(height: 20),
              isLoadingProducts
                  ? Center(child: CircularProgressIndicator())
                  : ProductGrid(
                      title: 'Tất cả sản phẩm',
                      products: products,
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
