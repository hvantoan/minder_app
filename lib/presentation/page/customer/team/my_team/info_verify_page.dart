import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

class InformationVerificationPage extends StatefulWidget {
  final Widget child;

  const InformationVerificationPage({Key? key, required this.child})
      : super(key: key);

  @override
  State<InformationVerificationPage> createState() =>
      _InformationVerificationPageState();
}

class _InformationVerificationPageState
    extends State<InformationVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 16.0),
              child: widget.child,
            ),
            _appBar()
          ],
        ),
      ),
    );
  }

  _appBar() {
    return Container(
      height: 56.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BaseShadowStyle.appBar]),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: BaseIcon.base(IconPath.arrowLeftLine)),
          Expanded(
              child: Text(
            S.current.lbl_info_verify,
            style: BaseTextStyle.label(),
            textAlign: TextAlign.center,
          )),
          const SizedBox(
            width: 56,
          )
        ],
      ),
    );
  }
}
