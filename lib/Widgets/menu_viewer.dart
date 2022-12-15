import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_incognito_browser/Provider/tab_provider.dart';
import 'package:new_incognito_browser/Screens/download_screen.dart';
import 'package:new_incognito_browser/Screens/settings_screen.dart';
import 'package:new_incognito_browser/Widgets/menu_item.dart';
import 'package:provider/provider.dart';

import '../Service/admob_service.dart';

class MenuViewer extends StatefulWidget {
  final InAppWebViewController? webViewController;
  final String url;

  const MenuViewer(
      {Key? key, required this.webViewController, required this.url})
      : super(key: key);

  @override
  State<MenuViewer> createState() => _MenuViewerState();
}

class _MenuViewerState extends State<MenuViewer> {
  BannerAd? bannerAd;

  createBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerUnitAdId!,
        listener: AdmobService.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  @override
  void initState() {
    createBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabProvider tabProvider = Provider.of(context);
    var nav = Navigator.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: bannerAd==null?MediaQuery.of(context).size.height * .4:MediaQuery.of(context).size.height * .5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              bannerAd==null?const SizedBox(
                height: 50,
              ):const SizedBox(
                height: 25,
              ),
              bannerAd == null
                  ? Container(
                      height: 20,
                      width: 20,
                      color: Colors.red,
                    )
                  : Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width - 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: AdWidget(
                        ad: bannerAd!,
                      ),
                    ),
              bannerAd!=null?const SizedBox(
                height: 25,
              ): Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .2 + 20,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomMenuItem(
                          itemIcon: Icons.search,
                          itemName: 'Find',
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          onTap: () {
                            tabProvider.toggleShowFindOnPage();
                            nav.pop();
                          },
                        ),
                        CustomMenuItem(
                          itemIcon: Icons.share,
                          itemName: 'Share',
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          onTap: () async {
                            nav.pop();
                            await share(widget.url);
                          },
                        ),
                        CustomMenuItem(
                          itemIcon: Icons.phone_android,
                          itemName: 'Full Screen',
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          itemIconColor: tabProvider.isFullScreen
                              ? Colors.blue
                              : Colors.black,
                          onTap: () {
                            tabProvider.toggleIsFullScreen();
                            if (tabProvider.isFullScreen) {
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.immersiveSticky);
                              nav.pop();
                            } else {
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.edgeToEdge);
                              nav.pop();
                            }
                          },
                        ),
                        CustomMenuItem(
                          itemIcon: Icons.dark_mode_outlined,
                          itemName: 'Dark Mode',
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          itemIconColor: tabProvider.isDarkMode
                              ? Colors.blue
                              : Colors.black,
                          onTap: () {
                            var val= tabProvider.isDarkMode;
                            tabProvider.toggleIsDarkMode(!val);
                            // await webViewController!.setOptions(
                            //     options: InAppWebViewGroupOptions(
                            //         android: AndroidInAppWebViewOptions(
                            //             forceDark: tabProvider.isDarkMode
                            //                 ? AndroidForceDark.FORCE_DARK_ON
                            //                 : AndroidForceDark
                            //                     .FORCE_DARK_OFF)));
                            // await webViewController!.reload();
                            nav.pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomMenuItem(
                          itemIcon: Icons.download_sharp,
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          itemName: 'Downloads',
                          onTap: () {
                            nav.pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DownloadScreen()));
                          },
                        ),
                        CustomMenuItem(
                          itemIcon: Icons.shield,
                          itemName: 'Ad-Block',
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          itemIconColor:
                              tabProvider.enableJs ? Colors.black : Colors.blue,
                          onTap: () async {
                            bool val = tabProvider.enableJs;
                            tabProvider.toggleEnableJs(!val);
                          },
                        ),
                        CustomMenuItem(
                          itemIcon: Icons.desktop_mac,
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          itemIconColor: tabProvider.isDesktopMode
                              ? Colors.blue
                              : Colors.black,
                          itemName: 'Desktop',
                          onTap: () async {
                            tabProvider.toggleIsDesktopMode();
                            await widget.webViewController!.setOptions(
                                options: InAppWebViewGroupOptions(
                                    crossPlatform: InAppWebViewOptions(
                                        preferredContentMode: tabProvider
                                                .isDesktopMode
                                            ? UserPreferredContentMode.DESKTOP
                                            : UserPreferredContentMode
                                                .RECOMMENDED)));
                            await widget.webViewController!.reload();
                            nav.pop();
                          },
                        ),
                        CustomMenuItem(
                          itemIcon: Icons.workspace_premium,
                          itemName: 'Premium',
                          itemTextColor: tabProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        nav.pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()));
                      },
                      child: Icon(
                        Icons.settings,
                        color: tabProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        size: 30,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        nav.pop();
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: tabProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        size: 30,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        }
                      },
                      child: Icon(
                        Icons.power_settings_new_rounded,
                        color: tabProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> share(String url) async {
    await FlutterShare.share(
      linkUrl: url,
      title: 'Incognito Browser',
    );
  }
}
