import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:new_incognito_browser/Provider/tab_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
class DownloaderViewer extends StatefulWidget {
  final String link;
  final String? name;
  const DownloaderViewer({
    Key? key,
    required this.link,
    this.name
  }) : super(key: key);

  @override
  State<DownloaderViewer> createState() => _DownloaderViewerState();
}

class _DownloaderViewerState extends State<DownloaderViewer> {
  TextEditingController link= TextEditingController();
  TextEditingController name= TextEditingController();
   FocusNode f1= FocusNode();
   FocusNode f2= FocusNode();
  @override
  void initState() {
    link.text=widget.link;
    name.text=widget.name??'';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var nav = Navigator.of(context);
    TabProvider tabProvider= Provider.of(context);
    OutlineInputBorder outlineBorder = OutlineInputBorder(
        borderSide:  BorderSide(
          color:tabProvider.isDarkMode ? Colors.white : Colors.black,
        ),
        borderRadius: BorderRadius.circular(5));
    return WillPopScope(
      onWillPop: ()async{
       if(f1.hasFocus||f2.hasFocus){
         f1.unfocus();
         f2.unfocus();
       }
       else{
         Navigator.pop(context);
       }
        return true;
      },
      child: SizedBox(
        height: f1.hasFocus||f2.hasFocus? MediaQuery.of(context).size.height * .5: MediaQuery.of(context).size.height * .35,
        child: GestureDetector(
          onTap: (){
            f1.unfocus();
            f2.unfocus();
          },
          child: Scaffold(
            backgroundColor: tabProvider.isDarkMode ? darkColor : whiteColor,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                       Text(
                        'Add Download',
                        style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: f1,
                        controller: TextEditingController(text: widget.link),
                        style: TextStyle(
                          color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Link',
                          labelStyle:  TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,),
                          border: outlineBorder,
                          focusedBorder: outlineBorder,
                          enabledBorder: outlineBorder,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,),
                        child: TextFormField(
                          focusNode: f2,
                          controller: TextEditingController(text: widget.name??''),
                          style: TextStyle(
                            color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color:tabProvider.isDarkMode ? Colors.white : Colors.black,),
                            border: outlineBorder,
                            focusedBorder: outlineBorder,
                            enabledBorder: outlineBorder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     const Text('Download Privately'),
                      //     Switch(value: tabProvider.downloadPrivately, onChanged: (val){
                      //         tabProvider.setDownloadPrivatelyValue(val);
                      //     }),
                      //   ],
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          },
                              child: Text('cancel',style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,),)),
                          TextButton(
                              onPressed: ()async{
                                if(await Permission.storage.isGranted){
                                  print('granteddd');
                                }
                               PermissionStatus status =await Permission.storage.request();
                               if(status.isGranted){
                                 nav.pop();
                                 print('granted');
                                 final taskId = await FlutterDownloader.enqueue(
                                   url: widget.link,
                                   //saveInPublicStorage: tabProvider.downloadPrivately?false:true,
                                   savedDir: (await getExternalStorageDirectory())!.path,
                                   // savedDir: (await getExternalStorageDirectory())!.path,
                                   showNotification: true, // show download progress in status bar (for Android)
                                   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                 );
                               }
                               else{
                                 nav.pop();
                               }

                          },
                              child: Text('Download',style: TextStyle(color: tabProvider.isDarkMode ? Colors.blue : Colors.blue,),)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
