import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_incognito_browser/Provider/tab_provider.dart';
import 'package:new_incognito_browser/Service/admob_service.dart';
import '../Constants/constants.dart';import 'package:new_incognito_browser/Widgets/downloader-viewer.dart';
import 'package:new_incognito_browser/Widgets/menu_viewer.dart';
import 'package:new_incognito_browser/Widgets/tab_viewer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/image_press_alert_dialog.dart';
import '../Widgets/long_press_alert_dialog.dart';

class WebViewTab extends StatefulWidget {
  String? url;
  String? title;
  Uint8List? screenshot;
  InAppWebViewController? webViewController;

  WebViewTab(
      {Key? key, this.url, this.title, this.screenshot, this.webViewController})
      : super(key: key);

  @override
  _WebViewTabState createState() => _WebViewTabState();
}

class _WebViewTabState extends State<WebViewTab> {
  final _focusNode = FocusNode();
  final _focusNode1 = FocusNode();
  bool showTf = false;
  String hintText = 'Search';
  final _searchController = TextEditingController();

  // final googleUrl = "https://www.google.com/search?q=";
  var webViewKey = UniqueKey();
  double progress = 0;
  bool canGoBack = false;
  UserPreferredContentMode userPreferredContentMode =
      UserPreferredContentMode.RECOMMENDED;
  late PullToRefreshController pullToRefreshController;
  bool canGoForward = false;
  CookieManager cookieManager = CookieManager();
  WebStorage? webStorage;
  bool isDesktopMode = false;
  final TextEditingController _finOnPageController = TextEditingController();
  InAppWebViewGroupOptions optionsNew = InAppWebViewGroupOptions();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          incognito: true,
          clearCache: true,
          cacheEnabled: false,
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          javaScriptCanOpenWindowsAutomatically: true,
          preferredContentMode: UserPreferredContentMode.RECOMMENDED),
      android: AndroidInAppWebViewOptions(
          databaseEnabled: false,
          useHybridComposition: true,
          supportMultipleWindows: true),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  BannerAd? bannerAd;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pauseAll();
    } else {
      resumeAll();
    }
  }

  void pauseAll() {
    if (Platform.isAndroid) {
      widget.webViewController?.android.pause();
    }
    pauseTimers();
  }

  void resumeAll() {
    if (Platform.isAndroid) {
      widget.webViewController?.android.resume();
    }
    resumeTimers();
  }

  void pause() {
    if (Platform.isAndroid) {
      widget.webViewController?.android.pause();
    }
  }

  void resume() {
    if (Platform.isAndroid) {
      widget.webViewController?.android.resume();
    }
  }

  void pauseTimers() {
    widget.webViewController?.pauseTimers();
  }

  void resumeTimers() {
    widget.webViewController?.resumeTimers();
  }

  OutlineInputBorder outlineBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      borderRadius: BorderRadius.circular(20));

  goBack() async {
    if (Navigator.canPop(context)) {
      await widget.webViewController!.canGoBack()
          ? widget.webViewController!.goBack()
          : Navigator.pop(context);
    } else {}
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _searchController.selection = TextSelection(
            baseOffset: 0, extentOffset: _searchController.text.length);
      }
    });
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          widget.webViewController?.reload();
          Provider.of<TabProvider>(context, listen: false).refresh();
        } else if (Platform.isIOS) {
          widget.webViewController?.loadUrl(
              urlRequest:
                  URLRequest(url: await widget.webViewController?.getUrl()));
        }
      },
    );
    createBannerAd();
    // optionsNew.crossPlatform.incognito = true;
    // optionsNew.android.useHybridComposition = true;
    super.initState();
  }

  createBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdmobService.bannerUnitAdId!,
        listener: AdmobService.bannerAdListener,
        request: const AdRequest())..load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _finOnPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabProvider tabProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: tabProvider.isDarkMode? darkColor:whiteColor,

      // backgroundColor: tabProvider.isDarkMode ? darkColor : Colors.white,
      body: WillPopScope(
        onWillPop: () {
          return goBack();
        },
        child: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                pullToRefreshController: pullToRefreshController,
                // initialOptions: optionsNew,
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        incognito: true,
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                        javaScriptCanOpenWindowsAutomatically: true,
                        preferredContentMode: tabProvider.isDesktopMode
                            ? UserPreferredContentMode.DESKTOP
                            : UserPreferredContentMode.RECOMMENDED),
                    android: AndroidInAppWebViewOptions(
                        databaseEnabled: false,
                        cacheMode: AndroidCacheMode.LOAD_NO_CACHE,
                        forceDark: tabProvider.isDarkMode
                            ? AndroidForceDark.FORCE_DARK_ON
                            : AndroidForceDark.FORCE_DARK_OFF,
                        useHybridComposition: true,
                        thirdPartyCookiesEnabled: false,
                        supportMultipleWindows: true),
                    ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                    )),
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url ?? '')),
                initialData:
                    widget.url!.isEmpty ? InAppWebViewInitialData(data:tabProvider.isDarkMode==false? """
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <style>
h1 {text-align: center;}
body {
text-align: center;
}
.container {
    position: absolute;
    top: 50%;
    left: 50%;
    -moz-transform: translateX(-50%) translateY(-50%);
    -webkit-transform: translateX(-50%) translateY(-50%);
    transform: translateX(-50%) translateY(-50%);
}
</style>
    </head>
    <body>
       <div class="container">
     <h2>Incognito Browser</h2>  
     <svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 401 401"><defs><style>.cls-1{fill:#fff;}.cls-2{fill:#0b0b0b;}.cls-2,.cls-3{fill-rule:evenodd;}</style></defs><title>ib_with_bg</title><circle class="cls-1" cx="200.5" cy="200.5" r="200.5"/><path class="cls-2" d="M183.6,252.44l-5.14-23.24s-44.3,6.71-46.49,24.11,37,36.14,37,36.14,33.77,14.69,86.1,15.5,84.36-14.63,84.36-14.63,41.35-15.73,42.21-35.33S336,230,336,230l-5.14,20.64s-11.45-44.18-21.51-66.32c-3.59-7.87-14.63-10.35-14.63-10.35a36.47,36.47,0,0,0-17.23,1.73c-7.75,2.84-14.81,9.66-19,9.49C250,185,239.11,173.75,223.21,174c-10.47.06-18.1,11.22-18.1,11.22a257.52,257.52,0,0,0-12,30.12A373.71,373.71,0,0,0,183.6,252.44Z" transform="translate(-57 -56)"/><path class="cls-3" d="M181,329.06l-1.73-14.63s17.46-4.22,35.32-3.47c20.71.92,37.07,6.88,42.22,6.88s24.34-6,45.62-6a142.35,142.35,0,0,1,32.72,4.28L332.55,329h-4.28s1,17.46-6.88,27.58c-6.53,8.27-22.37,9.48-22.37,9.48s-14.4.41-25-7.74c-10.06-7.75-11.63-24.12-16.37-24.12s-7.69,16.25-19,25c-9.14,7.06-22.38,6.88-22.38,6.88s-16.42-1-23.25-9.48c-7.74-9.54-6-27.58-6-27.58H181Z" transform="translate(-57 -56)"/></svg>
</div>
        
    </body>
</html>
                  """:"""
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <style>
h1 {text-align: center;}
body {
text-align: center;
}
.container {
    position: absolute;
    top: 50%;
    left: 50%;
    -moz-transform: translateX(-50%) translateY(-50%);
    -webkit-transform: translateX(-50%) translateY(-50%);
    transform: translateX(-50%) translateY(-50%);
}
</style>
    </head>
    <body>
       <div class="container">
     <h2>Incognito Browser</h2>  
     <svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 401 401"><defs><style>.cls-1{fill:#ff0000;}.cls-2{fill:#ff0000;}.cls-2,.cls-3{fill-rule:#ff0000;}</style></defs><title>ib_with_bg</title><circle class="cls-1" cx="200.5" cy="200.5" r="200.5"/><path class="cls-2" d="M183.6,252.44l-5.14-23.24s-44.3,6.71-46.49,24.11,37,36.14,37,36.14,33.77,14.69,86.1,15.5,84.36-14.63,84.36-14.63,41.35-15.73,42.21-35.33S336,230,336,230l-5.14,20.64s-11.45-44.18-21.51-66.32c-3.59-7.87-14.63-10.35-14.63-10.35a36.47,36.47,0,0,0-17.23,1.73c-7.75,2.84-14.81,9.66-19,9.49C250,185,239.11,173.75,223.21,174c-10.47.06-18.1,11.22-18.1,11.22a257.52,257.52,0,0,0-12,30.12A373.71,373.71,0,0,0,183.6,252.44Z" transform="translate(-57 -56)"/><path class="cls-3" d="M181,329.06l-1.73-14.63s17.46-4.22,35.32-3.47c20.71.92,37.07,6.88,42.22,6.88s24.34-6,45.62-6a142.35,142.35,0,0,1,32.72,4.28L332.55,329h-4.28s1,17.46-6.88,27.58c-6.53,8.27-22.37,9.48-22.37,9.48s-14.4.41-25-7.74c-10.06-7.75-11.63-24.12-16.37-24.12s-7.69,16.25-19,25c-9.14,7.06-22.38,6.88-22.38,6.88s-16.42-1-23.25-9.48c-7.74-9.54-6-27.58-6-27.58H181Z" transform="translate(-57 -56)"/></svg>
</div>
        
    </body>
</html>
                  """) : null,
                onWebViewCreated: (controller) async {
                  optionsNew.crossPlatform.incognito = true;
                  optionsNew.android.useHybridComposition = true;
                  optionsNew.android.forceDark = tabProvider.isDarkMode
                      ? AndroidForceDark.FORCE_DARK_ON
                      : AndroidForceDark.FORCE_DARK_OFF;
                  optionsNew.crossPlatform.preferredContentMode =
                      tabProvider.isDesktopMode
                          ? UserPreferredContentMode.DESKTOP
                          : UserPreferredContentMode.MOBILE;
                  // setState(() {
                  widget.webViewController = controller;
                  // });
                  await widget.webViewController!.setOptions(
                      options:
                          tabProvider.setOptions(widget.webViewController!));
                  // await controller.setOptions(options: optionsNew);
                },
                onLoadStart: (controller, url) async {
                  bool tempBackIconColor = await getBackIconColor();
                  bool tempForwardIconColor = await getForwardIconColor();
                  setState(() {
                    _searchController.text = url.toString();
                    showTf = false;
                    canGoBack = tempBackIconColor;
                    canGoForward = tempForwardIconColor;
                  });
                  // _webViewController!.android.clearHistory().then((value) => print('History cleared'));
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onLongPressHitTestResult: (controller, hitTestResult) async {
                  if (hitTestResult.type ==
                          InAppWebViewHitTestResultType.SRC_ANCHOR_TYPE ||
                      hitTestResult.type ==
                          InAppWebViewHitTestResultType.SRC_IMAGE_ANCHOR_TYPE) {
                    var requestFocusNodeHrefResult =
                        await widget.webViewController?.requestFocusNodeHref();
                    var url = requestFocusNodeHrefResult!.url.toString();
                    if (requestFocusNodeHrefResult != null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return LongPressAlertDialog(
                            url: url,
                          );
                        },
                      );
                    }
                  } else if (hitTestResult.type ==
                      InAppWebViewHitTestResultType.IMAGE_TYPE) {
                    var requestFocusNodeHrefResult =
                        await widget.webViewController?.requestFocusNodeHref();
                    var url = hitTestResult.extra;
                    if (requestFocusNodeHrefResult != null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ImagePressAlertDialog(
                            url: url!,
                          );
                        },
                      );
                    }
                  }
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  if (widget.webViewController != null) {
                    String tempTitle =
                        await widget.webViewController!.getTitle() ?? '';
                    var tempScreenshot = await controller.takeScreenshot(
                        screenshotConfiguration: ScreenshotConfiguration(
                      compressFormat: CompressFormat.JPEG,
                    ));
                    setState(() {
                      _searchController.text = url.toString();
                      hintText = tempTitle ?? 'Search';
                      widget.url = url.toString();
                      widget.screenshot = tempScreenshot;
                    });
                  }
                  webStorage = WebStorage(
                      localStorage:
                          widget.webViewController!.webStorage.localStorage,
                      sessionStorage:
                          widget.webViewController!.webStorage.sessionStorage);
                  webStorage!.sessionStorage.clear();
                  webStorage!.localStorage.clear();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onTitleChanged: (controller, getTitle) async {
                  getTitle = await controller.getTitle();
                  setState(() {
                    widget.title = getTitle!;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onDownloadStart: (controller, url) async {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor:
                          tabProvider.isDarkMode ? darkColor : whiteColor,
                      builder: (context) {
                        print(url.pathSegments);
                        return DownloaderViewer(
                            link: url.toString(), name: url.pathSegments.last);
                      });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var url = navigationAction.request.url;

                  if (url != null &&
                      ![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(url.scheme)) {
                    if (await canLaunch(url.toString())) {
                      // Launch the App
                      await launch(
                        url.toString(),
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
              ),
              tabProvider.showFindOnPage
                  ? Positioned(
                      top: 0,
                      child: Container(
                        color: tabProvider.isDarkMode ? darkColor : whiteColor,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width * .60,
                                child: TextField(
                                  focusNode: _focusNode1,
                                  onSubmitted: (value) {
                                    widget.webViewController
                                        ?.findAllAsync(find: value);
                                  },
                                  onChanged: (val) {
                                    widget.webViewController
                                        ?.findAllAsync(find: val);
                                  },
                                  controller: _finOnPageController,
                                  textInputAction: TextInputAction.go,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10.0),
                                    filled: true,
                                    fillColor: Colors.grey,
                                    border: outlineBorder,
                                    focusedBorder: outlineBorder,
                                    enabledBorder: outlineBorder,
                                    hintText: "Find on page ...",
                                    hintStyle: const TextStyle(
                                        color: Colors.black54, fontSize: 16.0),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                )),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_up,
                                    color: tabProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    widget.webViewController
                                        ?.findNext(forward: false);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: tabProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    widget.webViewController
                                        ?.findNext(forward: true);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: tabProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    widget.webViewController?.clearMatches();
                                    _finOnPageController.text = "";
                                    tabProvider.toggleShowFindOnPage();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                  : Container(),
              // Positioned(
              //     top: 50,
              //     child: bannerAd == null
              //         ? Container(
              //       height: 20,
              //       width: 100,
              //       color: Colors.red,
              //     )
              //         : Container(
              //       margin: const EdgeInsets.symmetric(horizontal: 10),
              //       child: AdWidget(
              //         ad: bannerAd!,
              //       ),
              //     )),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: tabProvider.isDarkMode ? darkColor : whiteColor,
                      border: Border.all(color: Colors.black, width: 0.03)),
                  child: showTf == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                await widget.webViewController!.canGoBack()
                                    ? widget.webViewController!.goBack()
                                    : Navigator.pop(context);
                              },
                              onLongPress: () {
                                tabProvider.moveToPreviousTab();
                              },
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: canGoBack
                                    ? tabProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black
                                    : tabProvider.isDarkMode
                                        ? Colors.black54
                                        : Colors.grey,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                widget.webViewController!.goForward();
                              },
                              onLongPress: () {
                                tabProvider.moveToNextTab();
                              },
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: canGoForward
                                    ? tabProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black
                                    : tabProvider.isDarkMode
                                        ? Colors.black54
                                        : Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showTf = true;
                                });
                              },
                              child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: tabProvider.isDarkMode
                                        ? const Color(0xff3e3d4b)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Center(
                                    child: Text(
                                      hintText,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: tabProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: tabViewer,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: tabProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      tabProvider.webViewTabs.length.toString(),
                                      style: TextStyle(
                                          color: tabProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: menuViewer,
                              child: Icon(
                                Icons.menu,
                                color: tabProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color:
                                tabProvider.isDarkMode ? darkColor : whiteColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              keyboardType: TextInputType.url,
                              focusNode: _focusNode,
                              controller: _searchController,
                              textInputAction: TextInputAction.go,
                              autofocus: true,
                              onSubmitted: (value) async {
                                var url = Uri.parse(value);
                                if (url.scheme.isEmpty) {
                                  url = Uri.parse(
                                      "${tabProvider.selectedSearchUrl}$value");
                                }
                                try {
                                  if (widget.webViewController != null) {
                                    widget.webViewController!.loadUrl(
                                        urlRequest: URLRequest(url: url));
                                    tabProvider.hideAd=true;
                                  }
                                } catch (e) {
                                  if (widget.webViewController != null) {
                                    widget.webViewController!.loadUrl(
                                        urlRequest: URLRequest(url: url));
                                  }
                                  log(e.toString());
                                  log(e.toString());
                                  log(e.toString());
                                  log(e.toString());
                                }
                              },
                              style: TextStyle(
                                color: tabProvider.isDarkMode
                                    ? Colors.black
                                    : Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(4),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: outlineBorder,
                                focusedBorder: outlineBorder,
                                enabledBorder: outlineBorder,
                                hintText: "Search for or type a web address",
                                hintStyle: TextStyle(
                                    color: tabProvider.isDarkMode
                                        ? Colors.black54
                                        : Colors.black54,
                                    fontSize: 16.0),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (_searchController.text.isEmpty) {
                                          showTf = false;
                                        } else {
                                          _searchController.clear();
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel_sharp,
                                      color: tabProvider.isDarkMode
                                          ? Colors.black
                                          : Colors.black,
                                    )),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 60,
                width: MediaQuery.of(context).size.width,
                child: progress < 1.0
                    ? LinearProgressIndicator(
                        value: progress,
                        color: Colors.black,
                        backgroundColor: Colors.grey,
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getBackIconColor() async {
    if (widget.webViewController != null) {
      if (await widget.webViewController!.canGoBack()) {
        return true;
      }
    }
    return false;
  }

  Future<bool> getForwardIconColor() async {
    if (await widget.webViewController!.canGoForward()) {
      return true;
    }
    return false;
  }

  tabViewer() {
    TabProvider tabProvider = Provider.of(context, listen: false);
    showModalBottomSheet(
        context: context,
        backgroundColor: tabProvider.isDarkMode ? darkColor : whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) {
          return const TabViewer();
        });
  }

  menuViewer() async {
    TabProvider tabProvider = Provider.of(context, listen: false);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: tabProvider.isDarkMode ? darkColor : whiteColor,
        builder: (context) {
          return MenuViewer(
            webViewController: widget.webViewController,
            url: _searchController.text,
          );
        });
  }
}
