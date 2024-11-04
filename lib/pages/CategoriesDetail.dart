import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/ProductItem.dart';
import 'package:hutech_cateen/services/apiProduct.dart';
import 'package:hutech_cateen/services/apiSubCategory.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class CategoriesDetail extends StatefulWidget {
  final String categoryID;
  const CategoriesDetail({required this.categoryID});

  @override
  State<CategoriesDetail> createState() => _CategoriesDetailState();
}

class _CategoriesDetailState extends State<CategoriesDetail> {
  bool isSearchActive = false;
  List subCategories = [];
  List products = [];
  List searchResults = [];
  String selectedCategory = '';
  String searchQuery = '';
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchSubCategories(widget.categoryID);
  }

  void fetchSubCategories(String categoryID) async {
    try {
      ApiSubCategoryService apiService = ApiSubCategoryService();
      List<dynamic> fetchedSubCategories =
          await apiService.getSubCategoriesByCategoryID(categoryID);

      setState(() {
        subCategories = fetchedSubCategories
            .map((subCategory) => {
                  'id': subCategory['_id'],
                  'name': subCategory['sc_name'],
                })
            .toList();

        if (subCategories.isNotEmpty) {
          selectedCategory = subCategories[0]['id'];
          fetchProductsBySubCategoryID(selectedCategory);
        }
      });
    } catch (e) {
      print('Error fetching subCategories: $e');
    }
  }

  void fetchProductsBySubCategoryID(String subCategoryID) async {
    try {
      ApiProduct apiService = ApiProduct();
      List<dynamic> fetchedProducts =
          await apiService.getProductsBySubCategoryID(subCategoryID);

      setState(() {
        products = fetchedProducts
            .map((product) => {
                  'productName': product['product_name'],
                  'productImage': product['product_thumb'],
                  'productID': product['_id'],
                  'productPrice': product['product_price'].toString(),
                })
            .toList();
        searchResults = products;
        searchQuery = '';
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      isLoading = false;
    }
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      searchResults = products.where((product) {
        return product['productName']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.orange),
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                        isSearchActive = false; // Đóng thanh tìm kiếm
                        searchQuery = ''; // Xóa giá trị tìm kiếm
                        fetchProductsBySubCategoryID(selectedCategory);
                      });
                    },
                    dropdownColor: Colors.white,
                    items: subCategories.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value['id'],
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            value['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            isSearchActive
                ? Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                      onChanged: handleSearch,
                      onSubmitted: (value) {
                        setState(() {
                          isSearchActive = false;
                        });
                      },
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          isSearchActive = true;
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 70),
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.3,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 50),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ProductItem(
                              productPrice: searchResults[index]
                                  ?['productPrice'],
                              productThumb: searchResults[index]
                                  ['productImage'],
                              title: searchResults[index]['productName'],
                              productID: searchResults[index]['productID']);
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
