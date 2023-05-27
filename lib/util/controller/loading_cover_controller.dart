import 'package:flutter/material.dart';
import 'package:minder/util/style/base_color.dart';

class LoadingCoverController {
  bool isActive = false;

  void _activate() {
    isActive = true;
  }

  void _inactivate() {
    isActive = false;
  }

  void on(BuildContext context) {
    off(context);
    _activate();
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return const Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                color: BaseColor.green600,
                strokeWidth: 5,
              ),
            ));
      },
    );
  }

  off(BuildContext context) {
    if (isActive) {
      _inactivate();
      Navigator.pop(context);
    }
  }
}
