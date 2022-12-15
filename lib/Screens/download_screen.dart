// import 'package:flutter/material.dart';
// import 'package:new_incognito_browser/Provider/tab_provider.dart';
// import 'package:new_incognito_browser/Screens/home_page.dart';
// import 'package:new_incognito_browser/Screens/web_view_tab.dart';
// import 'package:provider/provider.dart';
//
// import '../Widgets/tab_viewer.dart';
//
// class EmptyWebView extends StatefulWidget {
//   const EmptyWebView({Key? key}) : super(key: key);
//
//   @override
//   _EmptyWebViewState createState() => _EmptyWebViewState();
// }
//
// class _EmptyWebViewState extends State<EmptyWebView> {
//   final _focusNode = FocusNode();
//   bool showTf = false;
//   String hintText = 'Search';
//   final _searchController = TextEditingController();
//   final googleUrl = "https://www.google.com/search?q=";
//   OutlineInputBorder outlineBorder = OutlineInputBorder(
//       borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
//       borderRadius: BorderRadius.circular(20));
//   double progress = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     TabProvider tabProvider = Provider.of(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               color: Colors.white,
//               child: const Center(
//                 child: Text(
//                   'Incognito Browser',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               child: Container(
//                 height: 60,
//                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.black, width: 0.03)),
//                 child: showTf == false
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           InkWell(
//                             onTap: () {},
//                             child: const Icon(
//                               Icons.arrow_back_ios_outlined,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {},
//                             child: const Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 showTf = true;
//                               });
//                             },
//                             child: Container(
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade300,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 width: MediaQuery.of(context).size.width * .5,
//                                 child: Center(
//                                   child: Text(
//                                     hintText,
//                                     maxLines: 1,
//                                     style: const TextStyle(color: Colors.black),
//                                   ),
//                                 )),
//                           ),
//                           InkWell(
//                             onTap: tabViewer,
//                             child: Container(
//                               height: 40,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   border: Border.all(
//                                     color: Colors.black,
//                                   )),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     (tabProvider.webViewTabs.length ).toString(),
//                                     style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Icon(
//                             Icons.menu,
//                             color: Colors.black,
//                             size: 30,
//                           ),
//                         ],
//                       )
//                     : Container(
//                         width: MediaQuery.of(context).size.width,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: TextField(
//                             keyboardType: TextInputType.url,
//                             focusNode: _focusNode,
//                             controller: _searchController,
//                             textInputAction: TextInputAction.go,
//                             autofocus: true,
//                             onSubmitted: (value) {
//                               var url = Uri.parse(value);
//                               if (url.scheme.isEmpty) {
//                                 url = Uri.parse("$googleUrl$value");
//                               }
//                               tabProvider.launchUrlInTab(url.toString());
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => const HomePage()));
//                             },
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.all(4),
//                               filled: true,
//                               fillColor: Colors.grey.shade200,
//                               border: outlineBorder,
//                               focusedBorder: outlineBorder,
//                               enabledBorder: outlineBorder,
//                               hintText: "Search for or type a web address",
//                               hintStyle: const TextStyle(
//                                   color: Colors.black54, fontSize: 16.0),
//                               suffixIcon: InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       if (_searchController.text.isEmpty) {
//                                         showTf = false;
//                                       } else {
//                                         _searchController.clear();
//                                       }
//                                     });
//                                   },
//                                   child: const Icon(Icons.clear)),
//                             ),
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//             Positioned(
//               bottom: 60,
//               width: MediaQuery.of(context).size.width,
//               child: progress < 1.0
//                   ? LinearProgressIndicator(
//                       value: progress,
//                       color: Colors.black,
//                       backgroundColor: Colors.grey,
//                     )
//                   : Container(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   tabViewer() {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return const TabViewer();
//         });
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:new_incognito_browser/Provider/tab_provider.dart';
import '../Constants/constants.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final List<FileSystemEntity> _songs = [];
  List<FileSystemEntity> _files = [];

  _getFiles() async {
    Directory dir = (await getExternalStorageDirectory())!;
    String mp3Path = dir.toString();
    print(mp3Path);

    _files = dir.listSync(recursive: true, followLinks: false);
  }

  @override
  Widget build(BuildContext context) {
    TabProvider tabProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: tabProvider.isDarkMode? darkColor:whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Center(
                      child: Icon(
                        Icons.download_sharp,
                        size: 70,
                        color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Downloads',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                          //  color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _getFiles(),
                  builder: (context, snapshot) {
                    return _files.isNotEmpty? ListView.builder(
                        itemCount: _files.length,
                        itemBuilder: (context, int index) {
                          return InkWell(
                              onTap: () {
                                OpenFilex.open(
                                  _files[index].path.toString(),
                                );
                              },
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 1.5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 2))),
                                child: ListTile(
                                  title: Text(
                                    _files[index].uri.pathSegments.last,
                                    style:  TextStyle(
                                        //color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                                        fontSize: 18),
                                  ),
                                  leading:  Icon(
                                    Icons.file_download_done,
                                    color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  trailing: Container(
                                    height: 30,
                                    width: 30,
                                    child: PopupMenuButton(
                                      color: tabProvider.isDarkMode ? darkColor : whiteColor,
                                      child:  Center(
                                          child: Icon(Icons.more_vert_rounded,
                                              color: tabProvider.isDarkMode ? Colors.white : Colors.black,)),
                                      itemBuilder: (context) {
                                        return [
                                           PopupMenuItem(
                                              child: ListTile(
                                                onTap: (){
                                                  OpenFilex.open(
                                                    _files[index].path.toString(),
                                                  );
                                                },
                                                  title:  Text(
                                            'Open',
                                            // style:
                                            //     TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,),
                                          ))),
                                          PopupMenuItem(
                                              child: ListTile(
                                                  onTap: (){
                                                    FlutterShare.shareFile(title: _files[index].uri.pathSegments.last, filePath: _files[index].path);
                                                  },
                                                  title: Text(
                                                    'Share',
                                                    // style:
                                                    // TextStyle(color:tabProvider.isDarkMode ? Colors.white : Colors.black,),
                                                  ))),
                                          PopupMenuItem(
                                              child: ListTile(
                                                  onTap: (){
                                                    _files[index].delete();
                                                    _files.removeAt(index);
                                                    setState(() {

                                                    });
                                                  },
                                                  title:  Text(
                                                    'Delete',
                                                    // style:
                                                    // TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,),
                                                  ))),
                                        ];
                                      },
                                    ),
                                  ),
                                  //subtitle: Text(_files[index].uri.pathSegments.elementAt(i-1),style: const TextStyle(color: Colors.black,fontSize: 30),),
                                ),
                              ));
                        }):Center(child: Text('No downloads',
                      // style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,fontSize: 22),
                    ),);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
