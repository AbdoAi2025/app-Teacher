
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedInterstitialAds {

  RewardedInterstitialAd? _rewardedInterstitialAd;

  void load() {
    RewardedInterstitialAd.load(
      adUnitId: "ca-app-pub-2743920954571595/8295595205", // Replace with your real unit id
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("Rewarded Interstitial Loaded");
          _rewardedInterstitialAd = ad;
          _showRewardedInterstitialAd();
        },
        onAdFailedToLoad: (error) {
          print("Failed to load rewarded interstitial: $error");
          _rewardedInterstitialAd = null;
        },
      ),
    );
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      print("Ad not ready yet");
      return;
    }
    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print("User earned: ${reward.amount} ${reward.type}");
        // ✅ Give user reward here
      },
    );

  }


  void dispose() {
    _rewardedInterstitialAd?.dispose();
  }
}
