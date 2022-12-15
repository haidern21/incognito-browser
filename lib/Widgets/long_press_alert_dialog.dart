import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:toast/toast.dart';
import 'package:flutter_share/flutter_share.dart';

import '../Provider/tab_provider.dart';

class LongPressAlertDialog extends StatefulWidget {
  final String url;

  const LongPressAlertDialog({Key? key, required this.url}) : super(key: key);

  @override
  _LongPressAlertDialogState createState() => _LongPressAlertDialogState();
}

class _LongPressAlertDialogState extends State<LongPressAlertDialog> {
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
                onTap: () {
                  FlutterClipboard.copy(widget.url);
                  Navigator.pop(context);
                  initToast();
                  Toast.show("Url copied",
                      duration: Toast.lengthLong, gravity: Toast.center);
                },
                child: const ListTile(
                  title: Text('Copy'),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  await share();
                },
                child: const ListTile(
                  title: Text('Share'),
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

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }
}
