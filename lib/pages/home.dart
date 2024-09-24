import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/CategoryItem.dart';
import 'package:hutech_cateen/Components/ProductItem.dart';
import 'package:hutech_cateen/pages/CategoriesDetail.dart';
import 'package:hutech_cateen/services/apiCategory.dart';
import 'package:hutech_cateen/services/apiProduct.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

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
  // List categoriesID = [];
  List products = [];

  @override
  void initState() {
    super.initState();
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
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hey, Shivam,",
                        style: AppWidget.boldTextLargeFieldStyle()),
                    Text(
                      "Good morning!",
                      style: AppWidget.lightTextFieldStyle(),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "images/user.jpg",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(31, 212, 200, 200),
                  borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: AppWidget.lightTextFieldStyle(),
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Categories',
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                Row(
                  children: [
                    Text('See All', style: AppWidget.lightTextFieldStyle()),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.black45,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  height: 70,
                  margin: EdgeInsets.only(right: 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorWidget.primaryColor(),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), // Màu của bóng đổ
                        spreadRadius: 3, // Bán kính lan tỏa của bóng
                        blurRadius: 10, // Bán kính mờ của bóng

                        offset:
                            Offset(12, 10), // Độ lệch của bóng (trục x, trục y)
                      ),
                    ],
                  ),
                  width: 100,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset('images/food.png'),
                        ),
                      ),
                      SizedBox(width: 10),
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
                            padding: EdgeInsets.only(top: 10, bottom: 10),
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
                        : Center(child: Text("No categories available")),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Products',
                  style: AppWidget.semiboldTextFieldStyle(),
                ),
                Row(
                  children: [
                    Text('See All', style: AppWidget.lightTextFieldStyle()),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.black45,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 80),
            Container(
              margin: EdgeInsets.only(left: 10),
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
                          // Hardcode category ID for testing purpose
                        );
                      })
                  : Center(child: Text("No products available")),
            )
          ],
        ),
      ),
    );
  }
}
