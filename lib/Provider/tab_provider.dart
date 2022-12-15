import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:new_incognito_browser/Models/search_engine_model.dart';
import 'package:new_incognito_browser/Shared%20Prefferences/dark_mode_shared_preference.dart';
import 'package:new_incognito_browser/Shared%20Prefferences/desktop_mode_shared_preference.dart';
import 'package:new_incognito_browser/Shared%20Prefferences/enable_images_shared+preferences.dart';
import 'package:new_incognito_browser/Shared%20Prefferences/enable_js_shared_preferences.dart';
import 'package:new_incognito_browser/Shared%20Prefferences/full_screen_shared_preference.dart';
import 'package:new_incognito_browser/Shared%20Prefferences/search_engine_shared_preference.dart';
import '../Screens/web_view_tab.dart';

class TabProvider extends ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  DesktopModePreference desktopModePreference = DesktopModePreference();
  FullScreenPreference fullScreenPreference = FullScreenPreference();
  EnableJsPreference enableJsPreference = EnableJsPreference();
  EnableImagesPreference enableImagesPreference=EnableImagesPreference();
  SearchEngineSharedPreference searchEngineSharedPreference=SearchEngineSharedPreference();

  int tabIndex = -1;

  List<WebViewTab> webViewTabs = [ ];

  bool isDesktopMode = false;

  bool isFullScreen = false;

  bool isIncognito = false;

  bool showFindOnPage = false;

  bool isDarkMode = false;

  bool enableJs=false;

  bool enableImages=true;

  bool hideAd=false;

  bool downloadPrivately=true;

  String selectedSearchEngine='Google';
  String selectedSearchUrl='Google';

  SearchEngineModel selectedSearchEngineModel=searchEngines.first;


  initData() async {
    isDarkMode = await darkThemePreference.getTheme();
    isDesktopMode = await desktopModePreference.getDesktopMode();
    isFullScreen = await fullScreenPreference.getFullScreenMode();
    enableJs=await enableJsPreference.getEnableJs();
    enableImages=await enableImagesPreference.getEnableImages();
    selectedSearchEngine=await searchEngineSharedPreference.getSearchEngine();
    getSelectedSearchEngine();
    // for (var element in searchEngines) {
    //   if(element.name.trim()==selectedSearchEngine.trim()){
    //     selectedSearchEngineModel==element;
    //   }
    // }
    notifyListeners();
  }

  initTabs()async{
    var key =UniqueKey();
    if(webViewTabs.isEmpty){
      webViewTabs=[WebViewTab(url: '',key:key)];
      tabIndex=0;
    }
  }

   getSelectedSearchEngine()async{
    if(selectedSearchEngine=='Google'){
      selectedSearchUrl='https://www.google.com/search?q=';
    }
    if(selectedSearchEngine=='Yahoo'){
      selectedSearchUrl='https://www.yahoo.com/search?q=';
    }
    if(selectedSearchEngine=='Youtube'){
      selectedSearchUrl='https://www.youtube.com/search?q=';
    }
  }

  bool getThemeMode(){
    return isDarkMode;
  }

  updateSearchEngine(String? name){
    selectedSearchEngine=name??'Google';
    saveSearchEngine(name!);
    getSelectedSearchEngine();
    notifyListeners();
  }

  setDownloadPrivatelyValue(bool value){
    downloadPrivately=value;
    notifyListeners();
  }

  toggleEnableImages(bool val)async{
    enableImages=val;
    saveEnableImagesValue();
    for (int i = 0; i < webViewTabs.length; i++) {
      await webViewTabs[i].webViewController!.setOptions(options:setOptions(webViewTabs[i].webViewController!));
      await webViewTabs[i].webViewController!.reload();
    }
    notifyListeners();
  }


  toggleIsDarkMode(bool val) async {
    isDarkMode = val;
    saveDarkThemeValue();
    for (int i = 0; i < webViewTabs.length; i++) {
      // await webViewTabs[i].webViewController!.setOptions(
      //     options: InAppWebViewGroupOptions(
      //         crossPlatform: InAppWebViewOptions(
      //             preferredContentMode: isDesktopMode
      //                 ? UserPreferredContentMode.DESKTOP
      //                 : UserPreferredContentMode.MOBILE),
      //         android: AndroidInAppWebViewOptions(
      //             forceDark: isDarkMode
      //                 ? AndroidForceDark.FORCE_DARK_ON
      //                 : AndroidForceDark.FORCE_DARK_OFF)));
      await webViewTabs[i].webViewController!.setOptions(options:setOptions(webViewTabs[i].webViewController!));
      await webViewTabs[i].webViewController!.reload();
    }
    notifyListeners();
  }

  // enableJSValue(bool val) async {
  //   isDarkMode = val;
  //   saveDarkThemeValue();
  //   for (int i = 0; i < webViewTabs.length; i++) {
  //     await webViewTabs[i].webViewController!.setOptions(options:setOptions(webViewTabs[i].webViewController!));
  //     await webViewTabs[i].webViewController!.reload();
  //   }
  //   notifyListeners();
  // }

  saveDarkThemeValue() {
    darkThemePreference.setDarkTheme(isDarkMode);
  }

  saveSearchEngine(String value){
  searchEngineSharedPreference.setSearchEngine(value);
  }


  saveEnableImagesValue() {
    enableImagesPreference.setEnableImages(enableImages);
  }

  toggleShowFindOnPage() {
    showFindOnPage = !showFindOnPage;
    notifyListeners();
  }

  toggleEnableJs(bool onJs)async {
    enableJs = onJs;
    saveEnableJsValue();
    for (int i = 0; i < webViewTabs.length; i++) {
      await webViewTabs[i].webViewController!.setOptions(options:setOptions(webViewTabs[i].webViewController!));
      await webViewTabs[i].webViewController!.reload();
    }
    notifyListeners();
  }

  toggleIsDesktopMode() async {
    isDesktopMode = !isDesktopMode;
    saveDesktopModeValue();
    for (int i = 0; i < webViewTabs.length; i++) {
      // await webViewTabs[i].webViewController!.setOptions(
      //     options: InAppWebViewGroupOptions(
      //         crossPlatform: InAppWebViewOptions(
      //             preferredContentMode: isDesktopMode
      //                 ? UserPreferredContentMode.DESKTOP
      //                 : UserPreferredContentMode.MOBILE),
      //         android: AndroidInAppWebViewOptions(
      //             forceDark: isDarkMode
      //                 ? AndroidForceDark.FORCE_DARK_ON
      //                 : AndroidForceDark.FORCE_DARK_OFF)
      //     ));
      await webViewTabs[i].webViewController!.setOptions(options:setOptions(webViewTabs[i].webViewController!));
      await webViewTabs[i].webViewController!.reload();
    }
    notifyListeners();
  }

  refresh()async{
    log('refresh');
    log('refresh');
    log('refresh');
    for (int i = 0; i < webViewTabs.length; i++) {
      await webViewTabs[i].webViewController!.setOptions(options:setOptions(webViewTabs[i].webViewController!));
      // await webViewTabs[i].webViewController!.setOptions(
      //     options: InAppWebViewGroupOptions(
      //         crossPlatform: InAppWebViewOptions(
      //             preferredContentMode: isDesktopMode
      //                 ? UserPreferredContentMode.DESKTOP
      //                 : UserPreferredContentMode.MOBILE),
      //         android: AndroidInAppWebViewOptions(
      //             forceDark: isDarkMode
      //                 ? AndroidForceDark.FORCE_DARK_ON
      //                 : AndroidForceDark.FORCE_DARK_OFF)
      //     ));
      await webViewTabs[i].webViewController!.reload();
    }
    notifyListeners();
  }

  saveDesktopModeValue() {
    desktopModePreference.setDesktopMode(isDesktopMode);
  }

  saveEnableJsValue() {
    enableJsPreference.setEnableJs(enableJs);
  }

  toggleIsFullScreen() {
    isFullScreen = !isFullScreen;
    fullScreenPreference.setFullScreenMode(isFullScreen);
    notifyListeners();
  }

  launchUrlInTab(String url) {
    webViewTabs.add(WebViewTab(
      url: url,
      key: UniqueKey(),
    ));
    tabIndex = webViewTabs.length - 1;
    notifyListeners();
  }

  openSpecificTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  closeFirstTab(int index){
    webViewTabs= webViewTabs..removeAt(index);
    tabIndex=0;
    if(webViewTabs.isEmpty){
      webViewTabs.clear();
      webViewTabs.add(WebViewTab(url: '',key: UniqueKey(),));
      hideAd=false;
      // webViewTabs.add(WebViewTab(url: 'about:blank',key: UniqueKey(),));
      tabIndex=0;
    }
    notifyListeners();
  }

  closeSpecificTab(int index,BuildContext context) {
    log(index.toString());
    log(index.toString());
    log(index.toString());
    log(index.toString());
   if(webViewTabs.length==1){
     webViewTabs.removeAt(index);
     tabIndex=-1;
     if(webViewTabs.isEmpty){
       webViewTabs.clear();
       Navigator.pop(context);
       webViewTabs.add(WebViewTab(url: '',key: UniqueKey(),));
       hideAd=false;
       // webViewTabs.add(WebViewTab(url: 'about:blank',key: UniqueKey(),));
       tabIndex=0;
     }
     //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) => const HomePage())), (route) => false).then((value) => webViewTabs.clear());
   }

   else  if(webViewTabs.length>1&&index==0){
     tabIndex=index;
     webViewTabs.removeAt(tabIndex);
   }
   else if(webViewTabs.isEmpty){
     webViewTabs.clear();
     hideAd=false;
     webViewTabs.add(WebViewTab(url: '',key: UniqueKey(),));
     tabIndex=0;
   }
    else if(index!=0&& webViewTabs.length>1){
     webViewTabs.removeAt(index);
     tabIndex=index-1;
   }
    notifyListeners();
  }

  closeAllTabs(BuildContext context) {
    webViewTabs.clear();
    tabIndex=-1;
    if(webViewTabs.isEmpty){
      webViewTabs.clear();
      Navigator.pop(context);
      webViewTabs.add(WebViewTab(url: '',key: UniqueKey(),));
      hideAd=false;
      // webViewTabs.add(WebViewTab(url: 'about:blank',key: UniqueKey(),));
      tabIndex=0;
    }
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) => const HomePage())), (route) => false).then((value) => webViewTabs.clear());
    notifyListeners();
  }

  moveToPreviousTab() {
    tabIndex > 0 ? tabIndex-- : null;
    notifyListeners();
  }

  moveToNextTab() {
    tabIndex > webViewTabs.length ||
            tabIndex == webViewTabs.length ||
            tabIndex == webViewTabs.length + 1
        ? tabIndex++
        : null;
    notifyListeners();
  }

  InAppWebViewGroupOptions setOptions(InAppWebViewController controller){
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            incognito: true,
            clearCache: true,
            javaScriptEnabled: enableJs?true:false,
            cacheEnabled: false,
            useOnDownloadStart: true,
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            javaScriptCanOpenWindowsAutomatically: true,
            preferredContentMode: isDesktopMode
                ? UserPreferredContentMode.DESKTOP
                : UserPreferredContentMode.MOBILE),
        android: AndroidInAppWebViewOptions(
            databaseEnabled: false,
            useHybridComposition: true,
            useWideViewPort: false,
            clearSessionCache: true,
            thirdPartyCookiesEnabled: false,
            geolocationEnabled: false,
            loadsImagesAutomatically: enableImages?true:false,
            forceDark: isDarkMode
                ? AndroidForceDark.FORCE_DARK_ON
                : AndroidForceDark.FORCE_DARK_OFF,
            supportMultipleWindows: true),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ));
    return options;
    //return controller.setOptions(options: options );
  }
}
