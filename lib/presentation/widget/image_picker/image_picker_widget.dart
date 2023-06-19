import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/helper/string_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

const double _avatarCircleSize = 88.0;

class ImagePickerWidget {
  static Widget addCircle({VoidCallback? onTap, File? imagePath, String? url}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90.0,
        width: 95.0,
        padding: const EdgeInsets.only(bottom: 2.0, right: 8.0),
        child: Stack(
          children: [
            Container(
                height: _avatarCircleSize,
                width: _avatarCircleSize,
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: BaseColor.green400)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        height: _avatarCircleSize,
                        width: _avatarCircleSize,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: BaseColor.grey100),
                        child: Text(
                            StringHelper.createNameKey(
                                S.current.btn_create_team),
                            style: BaseTextStyle.label(color: BaseColor.grey300)
                                .copyWith(fontSize: _avatarCircleSize / 3))),
                    if (imagePath != null)
                      Container(
                        height: _avatarCircleSize,
                        width: _avatarCircleSize,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: BaseColor.grey200)),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(_avatarCircleSize),
                          child: Image.file(imagePath, fit: BoxFit.cover),
                        ),
                      ),
                    if (imagePath == null && url != null)
                      Container(
                        height: _avatarCircleSize,
                        width: _avatarCircleSize,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: BaseColor.grey200)),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(_avatarCircleSize),
                          child: Image.network(url, fit: BoxFit.cover),
                        ),
                      ),
                  ],
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 32.0,
                height: 32.0,
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                    color: BaseColor.blue500, shape: BoxShape.circle),
                child: BaseIcon.base(IconPath.cameraLine, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget addRectangle(
      {VoidCallback? onTap, File? imagePath, String? url}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 186.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: BaseColor.green400)),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: buildRectangle(imagePath, url),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 32.0,
                height: 32.0,
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                    color: BaseColor.blue500, shape: BoxShape.circle),
                child: BaseIcon.base(IconPath.cameraLine, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget buildRectangle(File? imagePath, String? url,
      {BoxFit fit = BoxFit.cover}) {
    if (imagePath != null) {
      return Container(
        height: 186.0,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: BaseColor.grey100)),
        child: Image.file(imagePath, fit: BoxFit.cover),
      );
    } else if (url != null) {
      return Container(
        height: 186.0,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: BaseColor.grey100)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                  child: Icon(
                Icons.replay_outlined,
                color: Colors.red,
                size: 32,
              ));
            },
          ),
        ),
      );
    }
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: BaseColor.grey100),
        child: BaseIcon.base(IconPath.pictureLine,
            size: const Size(56.0, 56.0), color: BaseColor.grey300));
  }
}
