# Live Football Flutter App Documentation

## Overview
A beautiful Flutter app for live football match streaming, scores, and news. Features theme switching, localization, AdMob ads, and persistent settings.

## Features
- Live football match list and details
- Video streaming for matches
- Theme switching (light/dark)
- Localization (English & Myanmar)
- Persistent user settings
- AdMob integration: banner, interstitial, native, app open ads
- Drawer navigation
- About & developer options screens

## Requirements
- Flutter 3.x or newer
- Dart 2.18 or newer
- Android/iOS/Web support
- AdMob account (for production ads)

## Installation
1. Clone the project:
	```
	git clone <your-repo-url>
	```
2. Install dependencies:
	```
	flutter pub get
	```
3. Run the app:
	```
	flutter run
	```

## AdMob Setup
- Update `lib/ads_manager.dart` with your own AdMob unit IDs:
	- Open `lib/ads_manager.dart` and replace all test AdMob IDs with your own from your AdMob account.
	- Example:
		```dart
		static const String bannerAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
		static const String interstitialAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
		static const String appOpenAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
		static const String nativeAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
		```
- Add your AdMob App ID to `android/app/src/main/AndroidManifest.xml`:
	```xml
	<meta-data
			android:name="com.google.android.gms.ads.APPLICATION_ID"
			android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
	```
	Replace with your real App ID from AdMob dashboard.

## Localization
- Uses [easy_localization](https://pub.dev/packages/easy_localization).
- Translation files in `assets/translations/`.
- Change language in Settings screen.

## Customization
- Edit theme in `lib/theme_cubit.dart`.
- Add new screens in `lib/screens/`.
- API logic in `lib/services/api_service.dart`.

### Change API URL
Open `lib/services/api_service.dart`.
Find the line with the base API URL, e.g.:
	```dart
	static const String baseUrl = 'https://football-live-stream-api.p.rapidapi.com';
	```
This API is available for purchase or subscription at:
	https://rapidapi.com/Thawtarlamin/api/football-live-stream-api
Replace `'https://football-live-stream-api.p.rapidapi.com'` with your own API endpoint if needed.
Save the file and restart the app.

### Change App Name
- Open `android/app/src/main/AndroidManifest.xml` and change the `android:label` property in the `<application>` tag:
	```xml
	<application
			android:label="Live Football"
			...>
	```
- For iOS, open `ios/Runner/Info.plist` and change the value for `CFBundleName` and `CFBundleDisplayName`.

### Change App Logo
- Replace the logo image files in:
	- `android/app/src/main/res/mipmap-*/ic_launcher.png` (for Android)
	- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (for iOS)
	- `web/favicon.png` (for web)
- You can use [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons) to automate icon generation:
	1. Add to `pubspec.yaml`:
		 ```yaml
		 dev_dependencies:
			 flutter_launcher_icons: ^0.13.1
		 flutter_icons:
			 android: true
			 ios: true
			 image_path: "assets/logo.png"
		 ```
	2. Run:
		 ```
		 flutter pub get
		 flutter pub run flutter_launcher_icons:main
		 ```

## Folder Structure
- `lib/` - Main app code
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` - Platform code
- `assets/` - Images, translations

## Support
For help, contact: itmyanmar.dev@gmail.com

## License
© 2025 IT Myanmar. All rights reserved.

---

Thank you for purchasing!
