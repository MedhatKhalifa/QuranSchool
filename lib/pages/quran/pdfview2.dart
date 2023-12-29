import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  TextEditingController _pageController = TextEditingController();
  String result = '';

  void performAction() {
    setState(() {
      result = "Go to page " + _pageController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to navigate to a specific page, e.g., '/home'
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.to(HomePage());
        return false; // Do not allow the default back button behavior
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
            //elevation: 0, // 2

            centerTitle: true,
            title:
                Text('Quran'.tr, style: const TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                ),
                onPressed: () {
                  _pdfViewerKey.currentState?.openBookmarkView();
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'page1') {
                    // Navigate to Page 1
                    Get.to(QuranPage());
                  } else if (value == 'page2') {
                    // Navigate to Page 2
                    Get.to(QuranPageAyaat());
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'page1',
                    child: Text('open_use_falsh'.tr),
                  ),
                  PopupMenuItem<String>(
                    value: 'page3',
                    child: Text('open_use_ayaat'.tr),
                  ),
                ],
              )
            ]),
        body: Center(
          child: SfPdfViewer.asset(
            'assets/quran.pdf',
            key: _pdfViewerKey,
            // canShowPaginationDialog: false,
            // pageSpacing: 0,
            ///  pageLayoutMode: PdfPageLayoutMode.single,
            //  maxZoomLevel: 1,
            //   enableDocumentLinkAnnotation: false
          ),
        ),
        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
