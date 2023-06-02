// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/style/base_style.dart';

class LanguageSetting extends StatefulWidget {
  LanguageSetting({
    super.key,
    required this.context,
    required this.languages,
    required this.onSuccess,
    required this.languageKey,
  });

  final BuildContext context;
  final List<Map<String, Object>> languages;
  final Function(String) onSuccess;
  String languageKey;

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: BaseColor.grey200, width: 1))),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 32,
                child: Text(S.current.lbl_language,
                    style: BaseTextStyle.label(color: BaseColor.grey900)),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    widget.onSuccess(widget.languageKey);
                    Navigator.of(context).pop();
                  },
                  child: Text(S.current.btn_done,
                      style: BaseTextStyle.label(color: BaseColor.green500)),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              widget.languages.length,
              (idx) => languageItem(
                context: context,
                onIndexChange: (value) {
                  setState(() {
                    widget.languageKey = value;
                  });
                },
                key: widget.languageKey,
                language: widget.languages[idx],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget languageItem({
    required BuildContext context,
    required Function(String) onIndexChange,
    required String key,
    required Map<String, Object> language,
  }) {
    return GestureDetector(
      onTap: () {
        onIndexChange(language['key'] as String);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: (key == language['key'])
                ? BaseColor.grey100
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                height: 24,
                child: Image.asset(language['imagePath'] as String),
              ),
              const SizedBox(width: 16),
              Text(
                language['name'] as String,
                style: BaseTextStyle.body1(
                  color: BaseColor.grey900,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
