import 'package:flutter/material.dart';
import 'package:new_incognito_browser/Helper/ThemeToggle.dart';
import 'package:new_incognito_browser/Provider/tab_provider.dart';
import 'package:provider/provider.dart';
import '../Constants/constants.dart';
import '../Models/search_engine_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    TabProvider tabProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: tabProvider.isDarkMode? darkColor:whiteColor,
       // backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
      body: SafeArea(
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
                  Icons.settings,
                  size: 70,
                  color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
             Center(
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: tabProvider.isDarkMode ? Colors.white : Colors.black,),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 2))),
                    child: ListTile(
                      title:  Text(
                        'Enable Javascript',
                        style: TextStyle(
                            color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle:  Text(
                        'Allow sites to run javascript',
                        style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black, fontSize: 14),
                      ),
                      trailing: Switch(
                          value: tabProvider.enableJs,
                          onChanged: (bool val) {
                            tabProvider.toggleEnableJs(val);
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 2))),
                    child: ListTile(
                      title:  Text(
                        'Force Dark Web Pages',
                        style: TextStyle(
                            color:tabProvider.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle: Text(
                        'Covert webpages to dark mode',
                        style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,fontSize: 14),
                      ),
                      trailing: Switch(value: tabProvider.isDarkMode, onChanged: (bool val) {
                        tabProvider.toggleIsDarkMode(!(tabProvider.isDarkMode));
                      }),
                      // trailing: SizedBox(
                      //     height: 50,
                      //     width: 50,
                      //     child: const ThemeToggle()),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 2))),
                    child: ListTile(
                      title:  Text(
                        'Enable Images ',
                        style: TextStyle(
                            color:tabProvider.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle: Text(
                        'Enable images to load in Web View',
                        style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,fontSize: 14),
                      ),
                      trailing: Switch(value: tabProvider.enableImages, onChanged: (bool val) {
                        tabProvider.toggleEnableImages(val);
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 2))),
                    child:  ListTile(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: double.maxFinite,
                                child:ListView.separated(
                                  shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return ListTile(
                                        onTap: (){
                                          tabProvider.updateSearchEngine(searchEngines[index].name);
                                        },
                                        leading: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: tabProvider.selectedSearchEngine==searchEngines[index].name? Colors.black:null
                                          ),
                                        ),
                                        title: Text(searchEngines[index].name!,),
                                      );
                                    },
                                    separatorBuilder: (context,index){
                                      return const SizedBox(height: 2,);
                                    },
                                    itemCount: searchEngines.length),
                              ),
                            );
                          },
                        );
                      },
                      title: Text(
                        'Search Engine',
                        style: TextStyle(
                            color:tabProvider.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle: Text(
                        'Choose a default search engine',
                        style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 2))),
                    child:  ListTile(
                      title: Text(
                        'What is new?',
                        style: TextStyle(
                            color:tabProvider.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle: Text(
                        'Check what we added in latest release',
                        style: TextStyle(color: tabProvider.isDarkMode ? Colors.white : Colors.black,fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 2))),
                    child:  ListTile(
                      title: Text(
                        'Feedback',
                        style: TextStyle(
                            color: tabProvider.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle: Text(
                        'Share your thoughts, we read every email',
                        style: TextStyle(color:tabProvider.isDarkMode ? Colors.white : Colors.black, fontSize: 14),
                      ),
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
}
