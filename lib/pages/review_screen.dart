import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/services/api_review.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

class ReviewScreen extends StatefulWidget {
  final String? orderID;
  final String? productID;

  const ReviewScreen({super.key, this.orderID, this.productID});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late TextEditingController _commentController;
  double _rating = 3.0; // Store the rating
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  final ApiReview apiReview = ApiReview(); // Create an instance of ApiReview

  @override
  void initState() {
    super.initState();
    _commentController =
        TextEditingController(); // Initialize the comment controller
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        final tempImage = File(pickedFile.path);
        final imageName = path.basename(tempImage.path);
        final appDir =
            await getApplicationDocumentsDirectory(); // Lấy thư mục ứng dụng
        final imagesDir = Directory('${appDir.path}/images');

        // Tạo thư mục images nếu chưa tồn tại
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        // Tạo đường dẫn mới cho hình ảnh
        final newImagePath = '${imagesDir.path}/$imageName';
        await tempImage
            .copy(newImagePath); // Sao chép hình ảnh vào thư mục images

        setState(() {
          _images.add(File(newImagePath)); // Thêm vào danh sách hình ảnh đã lưu
        });
      }
    }
  }

  Future<void> _submitReview() async {
    // Get the first two images or null if less than two are picked
    String? img1 =
        _images.isNotEmpty ? 'images/${path.basename(_images[0].path)}' : null;
    String? img2 =
        _images.length > 1 ? 'images/${path.basename(_images[1].path)}' : null;

    // Call the createReview function with the necessary parameters
    try {
      await apiReview.createReview(
        widget.orderID!,
        widget.productID!,
        img1,
        img2,
        _commentController.text,
        _rating,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đánh giá thành công!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đánh giá thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Đánh giá sản phẩm',
          style: AppWidget.boldTextMediumFieldStyle(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorWidget.primaryColor()),
        actions: [
          TextButton(
            onPressed: _submitReview, // Call the submitReview function
            child: Text(
              'Gửi',
              style: TextStyle(color: ColorWidget.primaryColor()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chất lượng sản phẩm',
                  style: AppWidget.boldTextSmallFieldStyle(),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  itemSize: 20,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: ColorWidget.primaryColor(),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating; // Update the rating
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon:
                      Icon(Icons.camera_alt, color: ColorWidget.primaryColor()),
                  label: Text(
                    'Thêm Hình ảnh',
                    style: AppWidget.semiboldSmallTextFieldStyle(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: ColorWidget.primaryColor()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _images.map((image) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorWidget.primaryColor()),
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Chất lượng sản phẩm: ',
                    style: AppWidget.boldTextSmallFieldStyle()),
                Text(
                  'để lại đánh giá',
                  style: AppWidget.descripe(),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _commentController, // Use the comment controller
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Hãy chia sẻ nhận xét cho sản phẩm này bạn nhé!',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
