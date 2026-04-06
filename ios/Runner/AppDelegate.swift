import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  var paymobHandler: PaymobHandler?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

    // Initialize Paymob handler
    paymobHandler = PaymobHandler(viewController: controller)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
