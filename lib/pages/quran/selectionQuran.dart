import 'dart:io';

import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/quran/pdfview2.dart';
import 'package:quranschool/pages/quran/quranPage%20copy.dart';
import 'package:quranschool/pages/quran/quranPage.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class QuranSelection extends StatefulWidget {
  const QuranSelection({super.key});

  @override
  State<QuranSelection> createState() => _QuranSelectionState();
}

class _QuranSelectionState extends State<QuranSelection> {
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/quran.pdf', 'quran.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Widget _buildImageWithShadow(
      {required String imageAsset,
      required VoidCallback onTap,
      required IconData myicon,
      required Color mycolor}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: w(25),
          height: h(20),
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(myicon, color: mycolor, size: sp(50)),
              Text(imageAsset)
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 221, 220, 220),
                blurRadius: 5,
                offset: Offset(1, -20),
              ),
            ],
            // image: DecorationImage(
            //   image: AssetImage(imageAsset),
            //   fit: BoxFit.fill,
            // ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(false, "Quran".tr),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/quran_1.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageWithShadow(
                      imageAsset: 'Ayaat', // Replace with your image asset
                      onTap: () {
                        Get.to(const QuranPage2());
                      },
                      myicon: FlutterIslamicIcons.quran2,
                      mycolor: Color.fromARGB(255, 120, 128, 17)),
                  _buildImageWithShadow(
                      imageAsset:
                          'Flash Quran', // Replace with your image asset
                      onTap: () {
                        Get.to(const QuranPage());
                      },
                      myicon: FlutterIslamicIcons.quran2,
                      mycolor: myorangeColor),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageWithShadow(
                      imageAsset: 'pdf'.tr, // Replace with your image asset
                      onTap: () {
                        Get.to(PdfView2());
                      },
                      myicon: FlutterIslamicIcons.quran,
                      mycolor: mybrowonColor),
                ],
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     // Navigate to the PDF screen
              //     Get.to(PdfView2());
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.picture_as_pdf),
              //       // Image.asset('assets/images/quran_1.jpg'),
              //       SizedBox(width: 10),
              //       Text('Quran PDF'),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigate to the WebView screen
              //     Get.to(const QuranPage());
              //   },
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.web),
              //       SizedBox(width: 10),
              //       Text('Quran Website - Flash'),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigate to the WebView screen
              //     Get.to(const QuranPage2());
              //   },
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.web),
              //       SizedBox(width: 10),
              //       Text('Quran Website - Ayaat'),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MybottomBar(),
    );
  }
}
