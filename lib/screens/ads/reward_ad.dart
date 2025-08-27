import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAds {

  RewardedAd? _rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-2743920954571595/8757246744", // Replace with your real Ad Unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print("Rewarded Ad Loaded");
          _rewardedAd = ad;
          _showRewardedAd();
        },
        onAdFailedToLoad: (error) {
          print("Failed to load rewarded ad: $error");
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print("Ad not ready");
      return;
    }
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print("User earned reward: ${reward.amount} ${reward.type}");
        // TODO: give the user reward (e.g., coins, premium access, etc.)
      },
    );
    _rewardedAd = null;
  }


  @override
  void dispose() {
    _rewardedAd?.dispose();
  }
}
