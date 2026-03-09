import Flutter
import UIKit
import AcceptSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

    // Paymob payment channel
    let paymobChannel = FlutterMethodChannel(name: "paymob_payment", binaryMessenger: controller.binaryMessenger)

    paymobChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "payWithCard":
        self?.payWithCard(call: call, result: result)
      case "payWithWallet":
        self?.payWithWallet(call: call, result: result)
      case "saveCard":
        self?.saveCard(call: call, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Paymob Payment Methods

  private func payWithCard(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let paymentKey = args["paymentKey"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Payment key is required", details: nil))
      return
    }

    let save = args["save"] as? Bool ?? false

    DispatchQueue.main.async {
      guard let controller = self.window?.rootViewController as? FlutterViewController else {
        result(FlutterError(code: "NO_CONTROLLER", message: "Unable to get view controller", details: nil))
        return
      }

      let acceptSDKViewController = AcceptSDKViewController()
      acceptSDKViewController.paymentKey = paymentKey
      acceptSDKViewController.saveCardDefault = save
      acceptSDKViewController.showSaveCard = save
      acceptSDKViewController.themeColor = UIColor(red: 0.098, green: 0.463, blue: 0.824, alpha: 1.0) // #1976D2

      acceptSDKViewController.paymentRequestCompletionHandler = { [weak self] (paymentData) in
        var paymentResult: [String: Any] = [:]

        if let paymentData = paymentData {
          paymentResult["success"] = true
          paymentResult["transaction_id"] = paymentData.transactionId
          paymentResult["paymob_transaction_id"] = paymentData.paymobTransactionId
          paymentResult["card_subtype"] = paymentData.cardSubType
          paymentResult["masked_pan"] = paymentData.maskedPan
          paymentResult["order_id"] = paymentData.orderId

          if let token = paymentData.token {
            paymentResult["card_token"] = token
            paymentResult["card_masked_pan"] = paymentData.maskedPan
          }
        } else {
          paymentResult["success"] = false
          paymentResult["error"] = "Payment failed"
        }

        result(paymentResult)
        controller.dismiss(animated: true, completion: nil)
      }

      acceptSDKViewController.errorBlock = { (error) in
        let errorResult: [String: Any] = [
          "success": false,
          "error": error?.localizedDescription ?? "Unknown payment error"
        ]
        result(errorResult)
        controller.dismiss(animated: true, completion: nil)
      }

      controller.present(acceptSDKViewController, animated: true, completion: nil)
    }
  }

  private func payWithWallet(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let paymentKey = args["paymentKey"] as? String,
          let redirectUrl = args["redirectUrl"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Payment key and redirect URL are required", details: nil))
      return
    }

    DispatchQueue.main.async {
      guard let controller = self.window?.rootViewController as? FlutterViewController else {
        result(FlutterError(code: "NO_CONTROLLER", message: "Unable to get view controller", details: nil))
        return
      }

      let walletViewController = AcceptSDKThreeDSViewController()
      walletViewController.paymentKey = paymentKey
      walletViewController.redirectionUrl = redirectUrl
      walletViewController.themeColor = UIColor(red: 0.098, green: 0.463, blue: 0.824, alpha: 1.0)

      walletViewController.paymentRequestCompletionHandler = { [weak self] (paymentData) in
        var paymentResult: [String: Any] = [:]

        if let paymentData = paymentData {
          paymentResult["success"] = true
          paymentResult["transaction_id"] = paymentData.transactionId
          paymentResult["paymob_transaction_id"] = paymentData.paymobTransactionId
          paymentResult["order_id"] = paymentData.orderId
        } else {
          paymentResult["success"] = false
          paymentResult["error"] = "Wallet payment failed"
        }

        result(paymentResult)
        controller.dismiss(animated: true, completion: nil)
      }

      walletViewController.errorBlock = { (error) in
        let errorResult: [String: Any] = [
          "success": false,
          "error": error?.localizedDescription ?? "Unknown wallet payment error"
        ]
        result(errorResult)
        controller.dismiss(animated: true, completion: nil)
      }

      controller.present(walletViewController, animated: true, completion: nil)
    }
  }

  private func saveCard(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let paymentKey = args["paymentKey"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Payment key is required", details: nil))
      return
    }

    DispatchQueue.main.async {
      guard let controller = self.window?.rootViewController as? FlutterViewController else {
        result(FlutterError(code: "NO_CONTROLLER", message: "Unable to get view controller", details: nil))
        return
      }

      let acceptSDKViewController = AcceptSDKViewController()
      acceptSDKViewController.paymentKey = paymentKey
      acceptSDKViewController.saveCardDefault = true
      acceptSDKViewController.showSaveCard = true
      acceptSDKViewController.themeColor = UIColor(red: 0.098, green: 0.463, blue: 0.824, alpha: 1.0)

      acceptSDKViewController.paymentRequestCompletionHandler = { [weak self] (paymentData) in
        var paymentResult: [String: Any] = [:]

        if let paymentData = paymentData {
          paymentResult["success"] = true
          paymentResult["transaction_id"] = paymentData.transactionId
          paymentResult["paymob_transaction_id"] = paymentData.paymobTransactionId
          paymentResult["card_subtype"] = paymentData.cardSubType
          paymentResult["masked_pan"] = paymentData.maskedPan
          paymentResult["order_id"] = paymentData.orderId

          if let token = paymentData.token {
            paymentResult["card_token"] = token
            paymentResult["card_masked_pan"] = paymentData.maskedPan
          }
        } else {
          paymentResult["success"] = false
          paymentResult["error"] = "Card save failed"
        }

        result(paymentResult)
        controller.dismiss(animated: true, completion: nil)
      }

      acceptSDKViewController.errorBlock = { (error) in
        let errorResult: [String: Any] = [
          "success": false,
          "error": error?.localizedDescription ?? "Unknown card save error"
        ]
        result(errorResult)
        controller.dismiss(animated: true, completion: nil)
      }

      controller.present(acceptSDKViewController, animated: true, completion: nil)
    }
  }
}
