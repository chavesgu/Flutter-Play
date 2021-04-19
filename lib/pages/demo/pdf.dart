import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../service/service.dart';
import '../../variable.dart';

class PDFView extends StatefulWidget {
  static const name = '/pdfView';

  PDFView();

  @override
  State<StatefulWidget> createState() => PDFViewState();
}

class PDFViewState extends State<PDFView> {
  PdfController? _pdfController;
  int currentPage = 0;
  int allPage = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('PDF View'),
          actions: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(right: width(30)),
              child: Text(
                '$currentPage/$allPage',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ))
          ],
        ),
      ),
      body: _pdfController != null
          ? PdfView(
              scrollDirection: Axis.vertical,
              documentLoader: Center(child: CircularProgressIndicator()),
              pageLoader: Center(child: CircularProgressIndicator()),
              controller: _pdfController!,
              onDocumentLoaded: (PdfDocument document) {
                setState(() {
                  currentPage = 1;
                  allPage = document.pagesCount;
                });
              },
              onDocumentError: (error) {
                print(error);
              },
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
            )
          : Container(),
    );
  }

  void _urlChange() async {
    String? url = Get.parameters['url'];
    if (url == null) return;
    Directory tempDir = Directory.systemTemp;
    String tempPath =
        tempDir.path + '/' + Uuid().v4() + '.pdf'; // /tmp ?? /Library/Caches
    try {
      await Service.download(url, tempPath);
    } catch (e) {
      print(e);
    }
    _pdfController = PdfController(
      document: PdfDocument.openFile(tempPath),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _urlChange();
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
