import 'package:flutter/material.dart';
import 'package:minder/util/style/base_style.dart';

import 'customer_bottom_navigation.dart';

class BottomNavigationItem extends StatelessWidget {
  const BottomNavigationItem({
    Key? key,
    required this.onTap,
    required this.isSelect,
    required this.selectedIconPath,
    required this.unselectedIconPath,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isSelect;
  final String selectedIconPath;
  final String unselectedIconPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
            height: bottomNavigatorHeight,
            width: (size.width - 24) * 0.2 - 3,
            color: Colors.transparent,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              BaseIcon.base(isSelect ? selectedIconPath : unselectedIconPath,
                  color: isSelect ? BaseColor.green500 : BaseColor.grey300),
              const SizedBox(height: 8),
              Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: BaseTextStyle.caption(
                          color:
                              isSelect ? BaseColor.green500 : BaseColor.grey300)
                      .copyWith(fontSize: 10))
            ])));
  }
}
