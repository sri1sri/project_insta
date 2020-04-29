//import 'dart:io' show Platform;
//import 'package:firebase_admob/firebase_admob.dart';
//
//import '../main.dart';
//
//MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//  keywords: <String>['games'],
//  contentUrl: 'https://flutter.io',
//  childDirected: false,
//  testDevices: <String>[], // Android emulators are considered test devices
//);
//
//BannerAd createBannerAd() {
//  return BannerAd(
//    adUnitId: BannerAd.testAdUnitId,
//
//    size: AdSize.smartBanner,
//    targetingInfo: targetingInfo,
//    listener: (MobileAdEvent event) {
//      // if (event == MobileAdEvent.loaded) {
//      //   bannerAd.show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
//      // }
//    },
//  );
//}

//  String getAppId() {
//    if (Platform.isIOS) {
//      return IOS_APP_ID;
//    } else if (Platform.isAndroid) {
//      return ANDROID_APP_ID;
//    }
//    return null;
//  }
//
//  String getBannerAdUnitId() {
//    if (Platform.isIOS) {
//      return IOS_AD_UNIT_BANNER;
//    } else if (Platform.isAndroid) {
//      return ANDROID_AD_UNIT_BANNER;
//    }
//    return null;
//  }

//  String IOS_APP_ID = 'ca-app-pub-9543395526409232~1075008136';
//  String ANDROID_APP_ID = 'ca-app-pub-9543395526409232~7748868325';

//  String IOS_AD_UNIT_BANNER = 'ca-app-pub-9543395526409232/1973797468';
//  String ANDROID_AD_UNIT_BANNER = 'ca-app-pub-9543395526409232/9656205735';
//
//
//




import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class Ads {
  static bool isShown = false;
  static bool _isGoingToBeShown = false;
  static BannerAd _bannerAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: Platform.isIOS ? 'ca-app-pub-9543395526409232~1075008136' : 'ca-app-pub-9543395526409232~7748868325');
  }

  static void setBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      //Platform.isIOS ? 'ca-app-pub-9543395526409232/1973797468' : 'ca-app-pub-9543395526409232/9656205735',
      size: AdSize.smartBanner,
      targetingInfo: _getMobileAdTargetingInfo(),
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          isShown = true;
          _isGoingToBeShown = false;
        } else if (event == MobileAdEvent.failedToLoad) {
          isShown = false;
          _isGoingToBeShown = false;
        }
        print("BannerAd event is $event");
      },
    );
  }

  static void showBannerAd([State state]) {
    if (state != null && !state.mounted) return;
    if (_bannerAd == null) setBannerAd();
    if (!isShown && !_isGoingToBeShown) {
      _isGoingToBeShown = true;
      _bannerAd
        ..load()
        ..show(anchorOffset: 70.0, anchorType: AnchorType.bottom);
    }
  }

  static void hideBannerAd() {
    if (_bannerAd != null && !_isGoingToBeShown) {
      _bannerAd.dispose().then((disposed) {
        isShown = !disposed;
      });
      _bannerAd = null;
    }
  }

  static void showInterstitialAd() {
    var interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: _getMobileAdTargetingInfo(),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    interstitialAd
      ..load()
      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
  }

  static void showRewardedVideoAd() {
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }
    };
    RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: _getMobileAdTargetingInfo());
  }

  static MobileAdTargetingInfo _getMobileAdTargetingInfo() {
    return MobileAdTargetingInfo(
      keywords: <String>['flower', 'identify flower', 'plant', 'tree', 'botany', 'identification key'],
      contentUrl: 'https://whatsthatflower.com/',
      childDirected: false,
      testDevices: <String>["E97A43B66C19A6831DFA72A48E922E5B"],
    );
  }
}