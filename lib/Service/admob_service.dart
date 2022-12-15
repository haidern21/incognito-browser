

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService{
  static String? get bannerUnitAdId{
    if(Platform.isAndroid){
      return"ca-app-pub-2820611334845092/4163395384";
    }
    return null;
  }

  static final BannerAdListener bannerAdListener=BannerAdListener(
    onAdLoaded: (ad)=>print('ad loaded'),
    onAdOpened: (ad)=>print('ad opened'),
    onAdClosed: (ad)=>print('ad closed'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      print(error);
    }

  );
}