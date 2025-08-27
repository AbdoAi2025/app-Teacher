


import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdsLoad{


  static InterstitialAd? _interstitialAd;
  static final String _adUnitId = "ca-app-pub-2743920954571595/9414834248"; // test ad

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.setImmersiveMode(true);
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                },
              );

          _showInterstitialAd();
        },
        onAdFailedToLoad: (error) {
          print("Interstitial failed to load: $error");
          _interstitialAd = null;
        },
      ),
    );
  }

  static void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("Ad not ready yet");
    }
  }

  static void dispose() {
    _interstitialAd?.dispose();
  }


}