import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialWithDialog extends StatefulWidget {

  @override
  _InterstitialWithDialogState createState() => _InterstitialWithDialogState();
}

class _InterstitialWithDialogState extends State<InterstitialWithDialog> {

  InterstitialAd? _interstitialAd;
  final String _adUnitId = "ca-app-pub-2743920954571595/9414834248"; // test ad

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
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
                  _loadInterstitialAd(); // Preload next one
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  _loadInterstitialAd();
                },
              );
        },
        onAdFailedToLoad: (error) {
          print("Interstitial failed to load: $error");
          _interstitialAd = null;
        },
      ),
    );
  }

  void _showDialogAndThenAd() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Do you want to continue?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                _showInterstitialAd();       // then show ad
              },
            ),
          ],
        );
      },
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("Ad not ready yet");
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Interstitial + Dialog")),
      body: Center(
        child: ElevatedButton(
          onPressed: _showDialogAndThenAd,
          child: Text("Open Dialog & Show Interstitial"),
        ),
      ),
    );
  }
}
