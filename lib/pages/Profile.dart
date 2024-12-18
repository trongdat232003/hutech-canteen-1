import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hutech_cateen/pages/discount_screen.dart';
import 'package:hutech_cateen/pages/edit_profile.dart';
import 'package:hutech_cateen/pages/favorite_screen.dart';
import 'package:hutech_cateen/pages/login.dart';
import 'package:hutech_cateen/pages/reviews_screen.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = '';
  String avatarUrl = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken'); // Retrieve the access token

    if (token != null) {
      try {
        // Make the API call to get user info
        final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/v2/api/user/getUserInfo'),
          headers: {
            'Authorization': token, // Include the access token
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          "Thông tin cá nhân",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl) // Tải hình từ URL
                          : AssetImage("images/user.jpg")
                              as ImageProvider, // Hình đại diện mặc định
                    ),
                    SizedBox(width: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.isNotEmpty
                              ? userName
                              : "Tên khách hàng", // Tên người dùng
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        // Thông điệp ngắn
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Thông tin cá nhân"),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewsScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Đánh giá"),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoriteScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Danh sách yêu thích"),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiscountScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.discount,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Kho voucher"),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Clear SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs
                              .clear(); // This will remove all stored data

                          // Navigate to the Login page
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) =>
                                false, // This removes all the previous routes from the stack
                          );
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.logout,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text("Đăng xuất"),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
