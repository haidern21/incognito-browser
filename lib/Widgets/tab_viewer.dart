import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Constants/constants.dart';import 'package:provider/provider.dart';
import '../Provider/tab_provider.dart';

class TabViewer extends StatefulWidget {
  const TabViewer({Key? key}) : super(key: key);

  @override
  State<TabViewer> createState() => _TabViewerState();
}

class _TabViewerState extends State<TabViewer> {
  @override
  void didUpdateWidget(TabViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      setState(() {});
    }
  }
    @override
  Widget build(BuildContext context) {
    TabProvider tabProvider = Provider.of(context,);
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * .4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .2 + 20,
                  child: ListView.builder(
                      key: Key(tabProvider.webViewTabs.length.toString()),
                      itemCount: tabProvider.webViewTabs.length + 1,
                      scrollDirection: Axis.horizontal,
                      // separatorBuilder: (context, index) {
                      //   return const SizedBox(
                      //     width: 15,
                      //   );
                      // },
                      itemBuilder: (context, index) {
                        if (index == tabProvider.webViewTabs.length) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  tabProvider.launchUrlInTab('');
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height * .2,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 3,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: tabProvider.isDarkMode
                                              ? darkColor
                                              : whiteColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: tabProvider.isDarkMode
                                                  ? Colors.black54.withOpacity(
                                                  0.3)
                                                  : Colors.grey.withOpacity(
                                                  0.5),
                                              spreadRadius: 3,
                                              blurRadius: 3,
                                              offset: const Offset(0,
                                                  4), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              5)),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: tabProvider.isDarkMode ? Colors
                                              .white : Colors.black,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return InkWell(
                          onTap: () {
                            tabProvider.openSpecificTab(index);
                            Navigator.pop(context);
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: tabProvider.isDarkMode ? Colors
                                            .black54.withOpacity(0.3) : Colors
                                            .grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 3,
                                        offset: const Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: tabProvider.tabIndex == index
                                            ? tabProvider.isDarkMode ? Colors
                                            .lightBlueAccent : Colors.black
                                            : Colors.transparent,
                                        width: 4)),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * .2,
                                child: SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * .2,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .height *
                                              .2 -
                                              30,
                                          width:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width / 3,
                                          child: tabProvider.webViewTabs[index]
                                              .screenshot !=
                                              null
                                              ? Image.memory(
                                            tabProvider.webViewTabs[index]
                                                .screenshot!,
                                            fit: BoxFit.cover,
                                          )
                                              : Container(
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height *
                                                .2 -
                                                30,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width /
                                                3,
                                            color: Colors.white,
                                          )),
                                      SizedBox(
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width / 3,
                                        child: Text(
                                          tabProvider.webViewTabs[index]
                                              .title ??
                                              '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 5,
                                  child: InkWell(
                                    onTap: () {
                                      if(index==0&&tabProvider.webViewTabs.length>1) {
                                        tabProvider.closeFirstTab(index);
                                      }
                                      else{
                                        tabProvider.closeSpecificTab(index, context);
                                      }

                                    },
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          CupertinoIcons.clear,
                                          size: 16,
                                          color: Colors.white,
                                        )),
                                  )),
                            ],
                          ),
                        );
                      }),
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
                          tabProvider.closeAllTabs(context);
                          setState((){

                          });
                        },
                        child: Text('CLEAR ALL',
                            style: TextStyle(
                                color: tabProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: tabProvider.isDarkMode ? Colors.white : Colors
                              .black,
                          size: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          tabProvider.launchUrlInTab('');
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ADD NEW',
                          style: TextStyle(
                              color: tabProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
