import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyInterstitialAdWidget extends StatefulWidget {
  /// The requested size of the banner. Defaults to [AdSize.banner].
  final AdSize adSize;

  /// The AdMob ad unit to show.
  ///
  /// TODO: replace this test ad unit with your own ad unit
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-2743920954571595/9414834248'
      // ... or this one on iOS.
      : 'ca-app-pub-3940256099942544/2934735716';

  MyInterstitialAdWidget({super.key, this.adSize = AdSize.fullBanner});

  @override
  State<MyInterstitialAdWidget> createState() => _MyInterstitialAdWidget();
}

class _MyInterstitialAdWidget extends State<MyInterstitialAdWidget> {

  AdWithView? _bannerAd;

  @override
  Widget build(BuildContext context) {
    debugPrint('MyInterstitialAdWidget _bannerAd: $_bannerAd');

    return SafeArea(
      child: SizedBox(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        child: _bannerAd == null
            // Nothing to render yet.
            ? const SizedBox()
            // The actual ad.
            : AdWidget(ad: _bannerAd!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() {
     InterstitialAd.load(
         adUnitId: widget.adUnitId,
         request: const AdRequest(),
         adLoadCallback: InterstitialAdLoadCallback(
             onAdLoaded: (ad){
               debugPrint('MyInterstitialAdWidget onAdLoaded: $ad');
               setState(() {
                 _bannerAd = ad as AdWithView?;
               });
             },
             onAdFailedToLoad: (error) {
               debugPrint('MyInterstitialAdWidget failed to load: $error');
             },
         ));
  }

}