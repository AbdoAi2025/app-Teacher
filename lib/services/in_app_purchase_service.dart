import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import '../utils/LogUtils.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance = InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  static const String _monthlySubscriptionId = 'monthly_subscription';
  static const String _yearlySubscriptionId = 'yearly_subscription';

  static const Set<String> _kIds = <String>{
    _monthlySubscriptionId,
    _yearlySubscriptionId,
  };

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;

  Future<void> initialize() async {
    appLog('Initializing In-App Purchase Service');

    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      appLog('In-App Purchase not available');
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => appLog('Purchase stream error: $error'),
    );

    await _loadProducts();
    await _restorePurchases();
  }

  Future<void> _loadProducts() async {
    appLog('Loading products');

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_kIds);

    if (response.notFoundIDs.isNotEmpty) {
      appLog('Products not found: ${response.notFoundIDs}');
    }

    if (response.error != null) {
      appLog('Error loading products: ${response.error}');
      return;
    }

    _products = response.productDetails;
    appLog('Loaded ${_products.length} products');

    for (final product in _products) {
      appLog('Product: ${product.id}, Price: ${product.price}, Title: ${product.title}');
    }
  }

  Future<void> _restorePurchases() async {
    appLog('Restoring purchases');
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      appLog('Error restoring purchases: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    appLog('Purchase update received: ${purchaseDetailsList.length} items');

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      appLog('Purchase status: ${purchaseDetails.status} for product: ${purchaseDetails.productID}');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  bool _verifyPurchase(PurchaseDetails purchaseDetails) {
    appLog('Verifying purchase for: ${purchaseDetails.productID}');
    return true;
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    appLog('Delivering product: ${purchaseDetails.productID}');
    _purchases.add(purchaseDetails);
  }

  void _handleError(IAPError error) {
    appLog('Purchase error: ${error.message} (${error.code})');
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    appLog('Invalid purchase: ${purchaseDetails.productID}');
  }

  void _showPendingUI() {
    appLog('Purchase pending...');
  }

  Future<bool> buyProduct(ProductDetails productDetails) async {
    if (!_isAvailable) {
      appLog('In-App Purchase not available');
      return false;
    }

    appLog('Initiating purchase for: ${productDetails.id}');

    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

      bool success;
      if (productDetails.id == _monthlySubscriptionId || productDetails.id == _yearlySubscriptionId) {
        success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        success = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }

      appLog('Purchase initiated: $success');
      return success;
    } catch (e) {
      appLog('Error initiating purchase: $e');
      return false;
    }
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      appLog('In-App Purchase not available');
      return;
    }

    await _restorePurchases();
  }

  bool hasActiveSubscription() {
    for (final purchase in _purchases) {
      if ((purchase.productID == _monthlySubscriptionId ||
           purchase.productID == _yearlySubscriptionId) &&
          purchase.status == PurchaseStatus.purchased) {
        return true;
      }
    }
    return false;
  }

  ProductDetails? getMonthlySubscription() {
    try {
      return _products.firstWhere((product) => product.id == _monthlySubscriptionId);
    } catch (e) {
      return null;
    }
  }

  ProductDetails? getYearlySubscription() {
    try {
      return _products.firstWhere((product) => product.id == _yearlySubscriptionId);
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    appLog('Disposing In-App Purchase Service');
    _subscription.cancel();
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}