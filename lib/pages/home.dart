import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/CategoryItem.dart';
import 'package:hutech_cateen/Components/ProductItem.dart';
import 'package:hutech_cateen/Components/_search.dart';
import 'package:hutech_cateen/Components/info_user.dart';
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
    "images/noodle.png",
    "images/rice.jpg",
    "images/snack.png"
  ];
  List categories = [];
  List products = [];
  String userName = '';
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchCategoriesFromApi();
    fetchProductsFromApi();
  }

  void fetchCategoriesFromApi() async {
    try {
      ApiCategoryService apiService = ApiCategoryService();
      List<dynamic> fetchedCategories = await apiService.getCategories();

      setState(() {
        categories = fetchedCategories
            .map((category) =>
                {'meal': category['meals'], 'id': category['_id']})
            .toList();
      });
    } catch (e) {
      print('Error fetching categories: $e');
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
                  'productID': product['_id']
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching products: $e');
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
              avatarUrl = user['avatar']
                  .replaceAll(r'\', '/'); // Fix the avatar URL format
              // Ensure to prefix with the base URL
              avatarUrl = 'http://10.0.2.2:3000/$avatarUrl';
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
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoUser(
              userName: userName,
              avatarUrl: avatarUrl.isNotEmpty
                  ? avatarUrl // Ensure to include the full URL
                  : 'images/user.jpg', // Handle empty URL case
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: const Text('Chỉnh sửa hồ sơ'),
            ),
            Search(),
            const SizedBox(
              height: 30,
            ),
            RowTitle(title: 'All Categories'),
            const SizedBox(
              height: 15,
            ),
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
                  width: 100,
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image(image: AssetImage('images/food.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'All',
                        style: AppWidget.boldTextSmallFieldStyle(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 80,
                    child: (categories.isNotEmpty)
                        ? ListView.builder(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                        : const Center(child: Text("No categories available")),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            RowTitle(title: 'All Products'),
            const SizedBox(height: 80),
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 130,
              child: (products.isNotEmpty)
                  ? ListView.builder(
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ProductItem(
                          image: 'images/pho.png',
                          title: products[index]['productName'],
                          productID: products[index]['productID'],
                        );
                      })
                  : const Center(child: Text("No products available")),
            ),
          ],
        ),
      ),
    );
  }
}
