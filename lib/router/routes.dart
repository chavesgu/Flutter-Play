import 'package:get/get.dart';

import 'path.dart';

List<GetPage> routes = [
  GetPage(
    name: SplashBanner.name,
    page: () => SplashBanner(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: EntryPage.name,
    page: () => EntryPage(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: ScanPage.name,
    page: () => ScanPage(),
    transition: Transition.cupertino,
    popGesture: true,
  ),
  GetPage(
    name: SettingPage.name,
    page: () => SettingPage(),
    transition: Transition.cupertino,
    popGesture: true,
  ),
  GetPage(
    name: TestFixedPage.name,
    page: () => TestFixedPage(),
    transition: Transition.cupertino,
    popGesture: true,
  ),
  GetPage(
    name: PDFView.name,
    page: () => PDFView(),
    transition: Transition.cupertino,
    popGesture: true,
  ),
  GetPage(
    name: MyWebView.name,
    page: () => MyWebView(),
    transition: Transition.cupertino,
    popGesture: true,
  ),
  GetPage(
    name: CanvasPage.name,
    page: () => CanvasPage(),
    transition: Transition.cupertino,
    popGesture: true,
  ),
  GetPage(
    name: ChartDemo.name,
    page: () => ChartDemo(),
    transition: Transition.cupertino,
    popGesture: true,
  ),
  GetPage(
    name: VideoDetailPage.name,
    page: () => VideoDetailPage(),
    transition: Transition.cupertino,
    popGesture: true,
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
