import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/bottom_navigation/bottom_navigator_item.dart';
import 'package:minder/presentation/widget/bottom_navigation/bottom_navigator_menu_component.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_style.dart';

const double addIconRadius = 34;
const double menuItemExtent = 64;
const double bottomNavigatorHeight = 64;
const double contentBottomPadding = bottomNavigatorHeight * 2 + 24;

class CustomerBottomNavigation extends StatelessWidget {
  const CustomerBottomNavigation(
      {Key? key, required this.currentIndex, required this.onIndexChange})
      : super(key: key);

  final int currentIndex;
  final Function(int) onIndexChange;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                height: bottomNavigatorHeight +
                    MediaQuery.of(context).padding.bottom,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  boxShadow: [BaseShadowStyle.bottomNavigation],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BottomNavigationItem(
                          onTap: () => onIndexChange(0),
                          isSelect: (currentIndex == 0),
                          selectedIconPath: IconPath.whistleFill,
                          unselectedIconPath: IconPath.whistleLine,
                          title: S.current.lbl_chat),
                      BottomNavigationItem(
                          onTap: () => onIndexChange(1),
                          isSelect: (currentIndex == 1),
                          selectedIconPath: IconPath.userGroupFill,
                          unselectedIconPath: IconPath.userGroupLine,
                          title: S.current.lbl_team),
                      SizedBox(
                          width:
                              (MediaQuery.of(context).size.width - 24) * 0.2 +
                                  12),
                      BottomNavigationItem(
                          onTap: () => onIndexChange(2),
                          isSelect: (currentIndex == 2),
                          selectedIconPath: IconPath.notificationFill,
                          unselectedIconPath: IconPath.notificationLine,
                          title: S.current.lbl_notification),
                      BottomNavigationItem(
                          onTap: () => onIndexChange(3),
                          isSelect: (currentIndex == 3),
                          selectedIconPath: IconPath.settingsFill,
                          unselectedIconPath: IconPath.settingsLine,
                          title: S.current.lbl_setting),
                    ])),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FocusedMenuHolder(
              menuWidth: size.width - 32,
              menuBoxDecoration: const BoxDecoration(color: Colors.transparent),
              onPressed: () {},
              openWithTap: true,
              animateMenuItems: false,
              blurSize: 1,
              menuItemExtent: menuItemExtent,
              menuOffset: 16,
              menuItems: [
                FocusedMenuItem(
                    title: BottomNavigatorMenuComponent(
                        content: S.current.lbl_find_member,
                        iconPath: IconPath.userLine),
                    onPressed: () {},
                    backgroundColor: Colors.transparent),
                FocusedMenuItem(
                    title: BottomNavigatorMenuComponent(
                        content: S.current.lbl_find_team,
                        iconPath: IconPath.userGroupLine),
                    onPressed: () {},
                    backgroundColor: Colors.transparent),
                FocusedMenuItem(
                    title: BottomNavigatorMenuComponent(
                        content: S.current.lbl_find_match,
                        iconPath: IconPath.whistleLine),
                    onPressed: () {},
                    backgroundColor: Colors.transparent),
              ],
              child: Container(
                height: addIconRadius * 2,
                width: addIconRadius * 2,
                padding: const EdgeInsets.all(6),
                margin: EdgeInsets.only(left: size.width / 2 - addIconRadius),
                decoration: const BoxDecoration(
                    color: BaseColor.green200, shape: BoxShape.circle),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      color: BaseColor.green500, shape: BoxShape.circle),
                  child:
                      BaseIcon.base(IconPath.searchLine, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ],
    );
  }
}
