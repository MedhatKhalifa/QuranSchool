import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/quran/quranPageAyaat.dart';
import 'package:quranschool/pages/quran/quranPageFlash.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView2 extends StatefulWidget {
  @override
  State<PdfView2> createState() => _PdfView2State();
}

class _PdfView2State extends State<PdfView2> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  TextEditingController _pageController = TextEditingController();
  String result = '';
  bool _isLoading = true;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void performAction() {
    setState(() {
      result = "Go to page " + _pageController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.to(HomePage());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appbar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            centerTitle: true,
            title:
                Text('Quran'.tr, style: const TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.white),
                onPressed: () {
                  _pdfViewerKey.currentState?.openBookmarkView();
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'page1') {
                    Get.to(QuranPage());
                  } else if (value == 'page2') {
                    Get.to(QuranPageAyaat());
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'page1',
                    child: Text('open_use_falsh'.tr),
                  ),
                ],
              ),
            ]),
        body: Stack(
          children: [
            Center(
              child: SfPdfViewer.asset(
                'assets/quran.pdf',
                key: _pdfViewerKey,
                onDocumentLoaded: (details) {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onDocumentLoadFailed: (details) {
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
            ),
            if (_isLoading)
              Center(
                child: LoadingBouncingGrid.circle(
                  borderColor: mybrowonColor,
                  backgroundColor: Colors.white,
                ),
              ),
          ],
        ),
        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
