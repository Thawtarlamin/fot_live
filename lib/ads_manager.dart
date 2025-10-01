import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String appOpenAdUnitId =
      'ca-app-pub-3940256099942544/3419835294';
  static const String nativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  static InterstitialAd? interstitialAd;
  static bool isInterstitialAdReady = false;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialAdReady = true;
          interstitialAd?.setImmersiveMode(true);
          interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              isInterstitialAdReady = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              isInterstitialAdReady = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (isInterstitialAdReady && interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
      isInterstitialAdReady = false;
    }
  }

  static AppOpenAd? appOpenAd;
  static bool isAppOpenAdReady = false;

  static void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          isAppOpenAdReady = true;
          appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              isAppOpenAdReady = false;
              loadAppOpenAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              isAppOpenAdReady = false;
              loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          isAppOpenAdReady = false;
        },
      ),
    );
  }

  static void showAppOpenAd() {
    if (isAppOpenAdReady && appOpenAd != null) {
      appOpenAd!.show();
      appOpenAd = null;
      isAppOpenAdReady = false;
    }
  }

  static NativeAd createNativeAd({required Function(NativeAd) onLoaded}) {
    final nativeAd = NativeAd(
      adUnitId: nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) => onLoaded(ad as NativeAd),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    nativeAd.load();
    return nativeAd;
  }
}
