import 'dart:io';

import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(false, "Quran"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   child: Text('quranflash'),
              //   onPressed: () {
              //     Get.to(const QuranPage());
              //   },
              // ),
              // ElevatedButton(
              //   child: Text('quran.ksu.edu'),
              //   onPressed: () {
              //     Get.to(const QuranPage2());
              //   },
              // ),
              // // ElevatedButton(
              // //   child: Text('quran pdf 1'),
              // //   onPressed: () {},
              // // ),
              // ElevatedButton(
              //   child: Text('quran pdf'),
              //   onPressed: () {
              //     Get.to(PdfView2());
              //   },
              // ),

              ElevatedButton(
                onPressed: () {
                  // Navigate to the PDF screen
                  Get.to(PdfView2());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf),
                    SizedBox(width: 10),
                    Text('Quran PDF'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the WebView screen
                  Get.to(const QuranPage());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.web),
                    SizedBox(width: 10),
                    Text('Quran Website - Flash'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the WebView screen
                  Get.to(const QuranPage2());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.web),
                    SizedBox(width: 10),
                    Text('Quran Website - Ayaat'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: mybottomBarWidget(),
    );
  }
}
