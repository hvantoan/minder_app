import 'package:flutter/material.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/util/style/base_style.dart';

class ListTileWidget {
  static base(
      {required String title,
      required List<Widget> children,
      required String textEmpty}) {
    return Padding(
      padding: const EdgeInsets.only(top: largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: BaseTextStyle.label()),
          ...children,
          if (children.isEmpty)
            Container(
              alignment: Alignment.centerLeft,
              height: 72.0,
              width: double.infinity,
              padding: const EdgeInsets.all(mediumPadding),
              margin: const EdgeInsets.only(top: mediumPadding + smallPadding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [BaseShadowStyle.common]),
              child: Text(
                textEmpty,
                style: BaseTextStyle.label(),
              ),
            )
        ],
      ),
    );
  }
}
