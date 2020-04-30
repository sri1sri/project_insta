

import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class Ads {
  static bool isShown = false;
  static bool _isGoingToBeShown = false;
  static BannerAd _bannerAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: Platform.isIOS ? 'ca-app-pub-6474281156947794~6979835268' : 'ca-app-pub-6474281156947794~6433040359');
  }

  static void showRewardedVideoAd() {
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }
    };
    RewardedVideoAd.instance.load(adUnitId: Platform.isIOS ? 'ca-app-pub-6474281156947794/3970528543' : 'ca-app-pub-6474281156947794/7362978645', targetingInfo: _getMobileAdTargetingInfo());
  }



  static MobileAdTargetingInfo _getMobileAdTargetingInfo() {
    return MobileAdTargetingInfo(
      keywords: <String>['games', 'Degree', 'social media', 'tree', 'shopping', 'Degree'],
      contentUrl: 'https://whatsthatflower.com/',
      childDirected: false,
      testDevices: <String>["E97A43B66C19A6831DFA72A48E922E5B"],
    );
  }
}