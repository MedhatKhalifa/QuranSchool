import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
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

  TextEditingController _pageController = TextEditingController();
  String result = '';

  void performAction() {
    setState(() {
      result = "Go to page " + _pageController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('Quran'.tr, style: const TextStyle(color: Colors.white)),
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
        ],
      ),
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
    );
  }
}
