import 'package:flutter/material.dart';

class CustomMenuItem extends StatelessWidget {
  final IconData itemIcon;
  final String itemName;
  final Color? itemIconColor;
  final Color? itemTextColor;
  final GestureTapCallback onTap;

  const CustomMenuItem({Key? key, required this.itemIcon, required this.itemName,required this.onTap,this.itemIconColor,this.itemTextColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Icon(
                  itemIcon,
                  color: itemIconColor??Colors.black,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              itemName,
              style: TextStyle(color: itemTextColor??Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
