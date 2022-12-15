import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_incognito_browser/Screens/home_page.dart';
import 'package:provider/provider.dart';
import 'Provider/tab_provider.dart';
import 'Theme/Theme_class.dart';
import 'Widgets/image_press_alert_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(
  //      testDeviceIds: <String>['A6890EAA3C837030D025D1CFAD498744'],
  //   ),
  // );

  // 1d2a9b5d-ef4d-42a2-a5bf-a17f88331edd
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  FlutterDownloader.registerCallback(TestClass.callback);
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<TabProvider>(
              create: (context) => TabProvider()),
        ],
        child: const MaterialApp(
          // theme: ThemeData(
          //   scaffoldBackgroundColor: Colors.white,
          // ),
          // darkTheme: ThemeData(
          //   scaffoldBackgroundColor: darkColor
          // ),
          // themeMode: ThemeMode.light,
          //themeMode:TabProvider().getThemeMode()==true?ThemeMode.dark: ThemeMode.light,
          // theme: ThemeData(
          //   // scaffoldBackgroundColor: TabProvider().getThemeMode()?Colors.yellow: Colors.red
          // ),
          // darkTheme: ThemeClass.darkTheme,
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ));
  }
}

