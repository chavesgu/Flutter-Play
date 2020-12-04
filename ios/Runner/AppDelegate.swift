import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// 防止插件弹出的uiview手势穿透到flutter层
extension UIViewController {
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      // DLog("\(self) \(#function)")
  }
}
