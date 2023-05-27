import 'package:flutter/material.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget {
  static base(
      {required double width,
      required double height,
      BoxShape? shape,
      BorderRadius? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: BaseColor.grey100,
      highlightColor: BaseColor.grey50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: shape ?? BoxShape.rectangle,
            borderRadius: borderRadius),
      ),
    );
  }
}
