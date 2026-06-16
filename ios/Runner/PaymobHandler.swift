import Flutter
import UIKit
import PaymobSDK

class PaymobHandler: PaymobSDKDelegate {
        

    // Global variable for SDK result
    var SDKResult: FlutterResult?

    weak var viewController: FlutterViewController?

    init(viewController: FlutterViewController) {
        self.viewController = viewController
//        super.init()
        setupMethodChannel()
    }

    // Code to handle receiving a call from Dart
    private func setupMethodChannel() {
        guard let controller = viewController else { return }

        let nativeChannel = FlutterMethodChannel(name: "paymob_sdk_flutter",
                                                 binaryMessenger: controller.binaryMessenger)

        nativeChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            if call.method == "payWithPaymob",
               let args = call.arguments as? [String: Any] {

                self.SDKResult = result
                self.callNativeSDK(arguments: args, VC: controller)

            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // Code to handle calling the native PaymobSDK
    // Function to call native PaymobSDK
    private func callNativeSDK(arguments: [String: Any], VC: FlutterViewController) {

        // Override app language so the SDK renders in the requested locale
        if let language = arguments["language"] as? String {
            UserDefaults.standard.set([language], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }

        // Initialize Paymob SDK
        let paymob = PaymobSDK()
        paymob.delegate = self

        // Customize the SDK
        if let appName = arguments["appName"] as? String {
            paymob.paymobSDKCustomization.appName = appName
        }

        if let buttonBackgroundColor = arguments["buttonBackgroundColor"] as? NSNumber {
            let colorInt = buttonBackgroundColor.intValue
            let alpha = CGFloat((colorInt >> 24) & 0xFF) / 255.0
            let red = CGFloat((colorInt >> 16) & 0xFF) / 255.0
            let green = CGFloat((colorInt >> 8) & 0xFF) / 255.0
            let blue = CGFloat(colorInt & 0xFF) / 255.0

            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            paymob.paymobSDKCustomization.buttonBackgroundColor = color
        }

        if let buttonTextColor = arguments["buttonTextColor"] as? NSNumber {
            let colorInt = buttonTextColor.intValue
            let alpha = CGFloat((colorInt >> 24) & 0xFF) / 255.0
            let red = CGFloat((colorInt >> 16) & 0xFF) / 255.0
            let green = CGFloat((colorInt >> 8) & 0xFF) / 255.0
            let blue = CGFloat(colorInt & 0xFF) / 255.0

            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            paymob.paymobSDKCustomization.buttonTextColor = color
        }

        if let saveCardDefault = arguments["saveCardDefault"] as? Bool {
            paymob.paymobSDKCustomization.saveCardDefault = saveCardDefault
        }

        if let showSaveCard = arguments["showSaveCard"] as? Bool {
            paymob.paymobSDKCustomization.showSaveCard = showSaveCard
        }

        // Call Paymob SDK with publicKey and clientSecret
        if let publicKey = arguments["publicKey"] as? String,
           let clientSecret = arguments["clientSecret"] as? String {
            do {
                try paymob.presentPayVC(VC: VC, PublicKey: publicKey, ClientSecret: clientSecret)
            } catch let error {
                print("PaymobHandler Error: \(error.localizedDescription)")
                SDKResult?(FlutterError(code: "PAYMOB_ERROR", message: error.localizedDescription, details: nil))
            }
            return
        } else {
            SDKResult?(FlutterError(code: "INVALID_ARGUMENTS", message: "Public key and client secret are required", details: nil))
        }
    }
    
    func transactionRejected() {
        print("PaymobIOS: Payment rejected")
        // Return error to match Android failure handling
        SDKResult?(FlutterError(code: "PAYMENT_FAILED", message: "Payment rejected", details: nil))
    }

    func transactionAccepted(transactionDetails: [String: Any]) {
        print("PaymobIOS: Payment successful")
        // Return "Successful" string to match Android implementation exactly
        SDKResult?("Successful")
    }

    func transactionPending() {
        print("PaymobIOS: Payment pending")
        // Return "Pending" string to match Android implementation
        SDKResult?("Pending")
    }
}
