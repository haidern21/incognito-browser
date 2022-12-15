// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:new_incognito_browser/Provider/tab_provider.dart';
// import 'package:provider/provider.dart';
//
// class ThemeToggle extends StatefulWidget {
//   const ThemeToggle({Key? key}) : super(key: key);
//
//   @override
//   State<ThemeToggle> createState() => _ThemeToggleState();
// }
//
// class _ThemeToggleState extends State<ThemeToggle> {
//
//   RxBool isLightTheme = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     TabProvider tabProvider= Provider.of(context);
//     return Scaffold(
//       body: ObxValue(
//             (data) => Switch(
//           value: isLightTheme.value,
//           onChanged: (val) {
//             isLightTheme.value = val;
//             Get.changeThemeMode(
//               isLightTheme.value ? ThemeMode.light : ThemeMode.dark,
//             );
//             tabProvider.toggleIsDarkMode(val);
//           },
//         ),
//         false.obs,
//       ),
//
//
//
//
//     );
//   }
// }
