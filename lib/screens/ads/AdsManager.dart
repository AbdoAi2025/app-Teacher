


import 'package:flutter/material.dart';
import 'package:teacher_app/screens/ads/reward_ad.dart';
import 'package:teacher_app/screens/ads/rewarded_interstitial_ad.dart';

import 'interstitial_ads_load.dart';
import 'my_banner_ad_widget.dart';

class AdsManager{

  static bool? isSubscribed;
  static final RewardedAds _rewardedAds = RewardedAds();
  static final RewardedInterstitialAds _rewardedInterstitialAds = RewardedInterstitialAds();


  static void loadRewardedInterstitialAd(){
    if(_isSubscribed()) return;
    _rewardedInterstitialAds.load();
  }

  static loadInterstitialAds(){
    if(_isSubscribed()) return;
    InterstitialAdsLoad.loadInterstitialAd();
  }

  static void loadRewardedAd(){
    if(_isSubscribed()) return;
    _rewardedAds.loadRewardedAd();
  }


  /*Screens*/
  static void showCreateGroupScreenAds() {
    loadRewardedAd();
  }

  static void showGroupDetailsScreenAds() {
    loadInterstitialAds();
  }

  static void showSessionDetailsScreenAds() {
    loadInterstitialAds();
  }

  static void showSessionListScreenAds() {
    loadInterstitialAds();
  }

  static void showAddStudentScreenAds() {
    loadRewardedAd();
  }

  static void showStudentDetailsScreenAds() {
    loadInterstitialAds();
  }

  static void showOnSendReportAds() {
    loadRewardedAd();
  }

  static Widget homeBanner() {
    if(!_isSubscribed()) {
      return  MyBannerAdWidget();
    }
    return SizedBox();
  }

  static bool _isSubscribed() => isSubscribed == true;

}