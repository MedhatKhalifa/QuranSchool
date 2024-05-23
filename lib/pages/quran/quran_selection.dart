import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/quran/pdfview2.dart';
import 'package:quranschool/pages/quran/quranPageFlash.dart';

class QuranSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(false, "Quran".tr),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildImageButton(
              context,
              'assets/images/q1.jpeg',
              'Read Quran offlne',
              PdfView2(),
            ),
            SizedBox(height: 20),
            buildImageButton(
              context,
              'assets/images/q2.jpeg',
              'Read Quran online',
              QuranPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MybottomBar(),
    );
  }

  Widget buildImageButton(
      BuildContext context, String assetPath, String label, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                assetPath,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
