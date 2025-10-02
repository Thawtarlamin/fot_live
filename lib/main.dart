import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';
import 'screens/splash_screen.dart';
import 'screens/match_list_screen.dart';
import 'screens/stream_player_screen.dart';
import 'screens/developer_options_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

import 'ads_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();
  AdsManager.loadAppOpenAd();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('my')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(create: (_) => ThemeCubit(), child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  void _checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Live Football',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
              primary: Colors.green,
              secondary: Colors.amber,
              onPrimary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
              primary: Colors.green,
              secondary: Colors.amber,
              onPrimary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
            useMaterial3: true,
          ),
          themeMode: themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/main': (context) => const MatchListScreen(),
            '/stream': (context) {
              final matchId =
                  ModalRoute.of(context)?.settings.arguments as String?;
              if (matchId == null) {
                return Scaffold(
                  body: Center(child: Text('No match selected'.tr())),
                );
              }
              return StreamPlayerScreen(url: matchId);
            },
            '/settings': (context) => const SettingsScreen(),
            '/about': (context) => const AboutScreen(),
            '/dev': (context) => const DeveloperOptionsScreen(),
          },
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}

// ...existing code...
