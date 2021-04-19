import 'package:get/get.dart';

import 'path.dart';

List<GetPage> routes = [
  GetPage(
    name: EntryPage.name,
    page: () => EntryPage(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: ScanPage.name,
    page: () => ScanPage(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: SettingPage.name,
    page: () => SettingPage(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: TestFixedPage.name,
    page: () => TestFixedPage(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: PDFView.name,
    page: () => PDFView(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: MyWebView.name,
    page: () => MyWebView(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: CanvasPage.name,
    page: () => CanvasPage(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: ChartDemo.name,
    page: () => ChartDemo(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: VideoDetailPage.name,
    page: () => VideoDetailPage(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: AudioDetailPage.name,
    page: () => AudioDetailPage(),
    transition: Transition.downToUp,
    popGesture: true,
  ),
];

// GetPage notFoundPage = GetPage(
//   name: name,
//   page: page,
//   transition: Transition.cupertino,
// );
