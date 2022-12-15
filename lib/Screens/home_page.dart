import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../Provider/tab_provider.dart';
import '../Service/admob_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? bannerAd;
  createBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerUnitAdId!,
        listener: AdmobService.bannerAdListener,
        request: AdRequest(

        ))..load();
  }
  @override
  void initState() {
    Provider.of<TabProvider>(context,listen: false).initData();
    Provider.of<TabProvider>(context,listen: false).initTabs();
    createBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabProvider tabProvider = Provider.of(context);
    // return Scaffold(
    //   body: _buildWebViewTabsContent(),
    // );
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: tabProvider.tabIndex,
            children: tabProvider.webViewTabs.map((e){
              return e;
            }).toList(),
          ),
          Positioned(
              top: 40,
              child: bannerAd == null
                  ? Container(
                height: 20,
                width: 20,
                color: Colors.red,
              )
                  : Container(
                height: 70,
                width:MediaQuery.of(context).size.width-20,
                margin:const EdgeInsets.symmetric(horizontal: 10),
                child: tabProvider.hideAd==false?AdWidget(
                  ad: bannerAd!,
                ): Container(),
              )),
        ],
      ),
    );
  }

  Widget _buildWebViewTabsContent() {
    TabProvider tabProvider = Provider.of(context);
    var stackChildren = <Widget>[
      IndexedStack(
        index: tabProvider.tabIndex,
        children: tabProvider.webViewTabs.map((webViewTab) {
          return webViewTab;
        }).toList(),
      ),
    ];

    return tabProvider.tabIndex==-1?Container(color: Colors.red,):Stack(
      children: stackChildren,
    );
  }
}
