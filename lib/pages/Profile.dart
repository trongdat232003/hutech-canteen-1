import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          "Profile",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz, // Dấu 3 chấm
              color: Colors.black, // Màu đen cho dấu 3 chấm
            ),
            onPressed: () {
              // Xử lý khi bấm vào dấu 3 chấm
            },
          ),
        ],
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
                      backgroundImage: AssetImage("images/user.jpg"),
                    ),
                    SizedBox(width: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Visa Khadock",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("I love fast food"),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
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
                      Row(
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
                          Text("Person info"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.my_location,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Addresses"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
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
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              FeatherIcons.shoppingCart,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Log out"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.heart_broken_rounded,
                              color: Colors.purple,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Favorite"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.notification_important,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Notification"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.payment,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Payment"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.question_answer,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("FAQs"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.reviews,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("User review"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.settings,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Settings"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.logout_outlined,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Log out"),
                          SizedBox(
                            width: 190,
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
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
