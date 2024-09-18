import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories = [
    "images/drink.png",
    "images/noodle.png",
    "images/rice.png",
    "images/snack.png"
  ];
  List categoriesName = ["Đồ uống", "Món nước", "Món cơm", "Ăn vặt"];

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
                    color: const Color.fromARGB(255, 245, 177, 76),
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
                          child: Image.asset(
                              'images/food.png'), // Để màu nền của CircleAvatar trong suốt
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
                    height: 90,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            image: categories[index],
                            title: categoriesName[index],
                          );
                        }),
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
              height: 140,
              child: ListView(
                clipBehavior: Clip.none,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      width: 160,
                      margin: EdgeInsets.only(right: 15),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.1), // Màu của bóng đổ
                            spreadRadius: 8, // Bán kính lan tỏa của bóng
                            blurRadius: 18, // Bán kính mờ của bóng

                            offset: Offset(
                                10, 10), // Độ lệch của bóng (trục x, trục y)
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -60,
                            right: 30,
                            child: Image.asset(
                              "images/rice.png",
                              height: 100,
                              width: 100,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Bánh tráng trộn',
                                style: AppWidget.boldTextMediumFieldStyle(),
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '70 VNĐ',
                                    style:
                                        AppWidget.semiboldSmallTextFieldStyle(),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(24, 24),
                                      shape: CircleBorder(),
                                      backgroundColor: Color.fromARGB(255, 245,
                                          177, 76), // <-- Button color
                                      foregroundColor:
                                          Colors.red, // <-- Splash color
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image;
  String title;
  CategoryTile({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Màu của bóng đổ
            spreadRadius: 1, // Bán kính lan tỏa của bóng
            blurRadius: 16, // Bán kính mờ của bóng

            offset: Offset(8, 8), // Độ lệch của bóng (trục x, trục y)
          ),
        ],
      ),
      width: 148,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 253, 236, 192), // Màu của bóng đổ
                  spreadRadius: 0.1, // Tỏa rộng bóng
                  blurRadius: 10, // Độ mềm mại của bóng
                  offset: Offset(0, 3), // Độ lệch của bóng (trục x, trục y)
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor:
                  Colors.transparent, // Để màu nền của CircleAvatar trong suốt
              child: Image.asset(
                image,
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: AppWidget.boldTextSmallFieldStyle(),
          )
        ],
      ),
    );
  }
}
