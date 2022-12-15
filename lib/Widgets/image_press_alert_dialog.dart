import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:toast/toast.dart';
import 'package:flutter_share/flutter_share.dart';
import '../Provider/tab_provider.dart';
import '../Constants/constants.dart';
import 'downloader-viewer.dart';

class ImagePressAlertDialog extends StatefulWidget {
  final String url;

  const ImagePressAlertDialog({Key? key, required this.url}) : super(key: key);

  @override
  _ImagePressAlertDialogState createState() => _ImagePressAlertDialogState();
}

class _ImagePressAlertDialogState extends State<ImagePressAlertDialog> {
  @override
  Widget build(BuildContext context) {
    TabProvider tabProvider = Provider.of(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  tabProvider.launchUrlInTab(widget.url);
                  Navigator.pop(context);
                },
                child: const ListTile(
                  title: Text('Open In New Tab'),
                ),
              ),
              InkWell(
                onTap: ()async {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor:
                      tabProvider.isDarkMode ? darkColor : whiteColor,
                      builder: (context) {
                        return DownloaderViewer(
                            link: widget.url, name: '');
                      });
                  // Plugin must be initialized before using

                  // final taskId = await FlutterDownloader.enqueue(
                  //   url: widget.url,
                  //   saveInPublicStorage: true,
                  //   savedDir:  (await getExternalStorageDirectory())!.path,
                  //   showNotification: true, // show download progress in status bar (for Android)
                  //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                  // );
                },
                child: const ListTile(
                  title: Text('Download Image'),
                ),
              ),
              InkWell(
                onTap: () {
                  FlutterClipboard.copy(widget.url);
                  Navigator.pop(context);
                  initToast();
                  Toast.show("Image address copied",
                      duration: Toast.lengthLong, gravity: Toast.center);
                },
                child: const ListTile(
                  title: Text('Copy image address'),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  await share(widget.url);
                },
                child: const ListTile(
                  title: Text('Share image'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  initToast() {
    ToastContext().init(context);
  }

  Future<void> share(String url) async {
    await FlutterShare.share(
      linkUrl: url,
      title: 'Incognito Browser',
    );
  }
}
class TestClass{
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}