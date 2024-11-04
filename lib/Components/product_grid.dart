import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/ProductItem.dart';
import 'package:hutech_cateen/Components/row_title.dart';

class ProductGrid extends StatelessWidget {
  final String title;
  final List products;

  const ProductGrid({
    Key? key,
    required this.title,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowTitle(title: title),
        products.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.only(top: 70),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.3,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 50,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductItem(
                    title: products[index]['productName'],
                    productID: products[index]['productID'],
                    productThumb: products[index]['productThumb'],
                    productPrice: products[index]['productPrice'],
                  );
                },
              )
            : const Center(child: Text("Không có sản phẩm nào")),
      ],
    );
  }
}
