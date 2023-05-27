import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_style.dart';

class TextFieldWidget {
  static Widget base({
    required ValueChanged<String> onChanged,
    String? labelText,
    String? hintText,
    String? errorText,
    String? initialValue,
    bool required = false,
    bool isObscured = false,
    bool enable = true,
    EdgeInsets? contentPadding,
    FocusNode? focusNode,
    TextEditingController? textEditingController,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool autoFocus = false,
    int? maxLength,
    int? maxLines,
    bool isSearch = false,
    Color? fillColor,
    bool readOnly = false,
    TextStyle? textStyle,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical textAlignVertical = TextAlignVertical.center,
    TextInputAction? textInputAction,
    VoidCallback? onSuffixIconTap,
    VoidCallback? onPrefixIconTap,
    String? prefixIconPath,
    String? suffixIconPath,
    TextInputType? textInputType,
  }) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((labelText != null))
            Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(labelText,
                      style: BaseTextStyle.label(
                          color: enable ? null : BaseColor.grey500)),
                  if (required)
                    Text(" *",
                        style: BaseTextStyle.label(
                            color:
                                enable ? BaseColor.red500 : BaseColor.grey500))
                ])),
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            enabled: enable,
            readOnly: readOnly,
            obscureText: isObscured,
            cursorColor: BaseColor.green600,
            cursorWidth: 2,
            cursorHeight: 20,
            cursorRadius: const Radius.circular(2),
            showCursor: enable,
            style: enable
                ? textStyle ?? BaseTextStyle.body1()
                : BaseTextStyle.body1(color: BaseColor.grey500),
            focusNode: focusNode,
            controller: textEditingController,
            autofocus: autoFocus,
            textAlign: textAlign,
            textCapitalization: textCapitalization,
            textAlignVertical: textAlignVertical,
            textInputAction: textInputAction,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            keyboardType: textInputType,
            decoration: InputDecoration(
              //Set counter text
              counterText: "",
              prefixIcon: prefixIconPath != null
                  ? IconButton(
                      onPressed: onPrefixIconTap != null
                          ? () => onPrefixIconTap()
                          : () {},
                      icon: BaseIcon.base(prefixIconPath,
                          color: BaseColor.grey300))
                  : null,
              suffixIcon: suffixIconPath != null
                  ? IconButton(
                      onPressed: onSuffixIconTap != null
                          ? () => onSuffixIconTap()
                          : () {},
                      icon: BaseIcon.base(suffixIconPath,
                          color: BaseColor.grey300))
                  : null,
              hintText: hintText,
              fillColor:
                  fillColor ?? (enable ? Colors.white : BaseColor.grey200),
              filled: true,
              contentPadding: contentPadding ??
                  EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: prefixIconPath != null ? 0 : 16,
                      right: suffixIconPath != null ? 0 : 16),
              hintStyle: BaseTextStyle.body1(color: BaseColor.grey300),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isSearch ? 40.0 : 12.0),
                  borderSide: isSearch
                      ? BorderSide.none
                      : BorderSide(
                          color: errorText != null
                              ? BaseColor.red500
                              : BaseColor.grey200,
                          width: 1,
                        )),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isSearch ? 40.0 : 12.0),
                  borderSide: isSearch
                      ? BorderSide.none
                      : const BorderSide(color: BaseColor.grey200)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSearch ? 40.0 : 12.0),
                borderSide: isSearch
                    ? BorderSide.none
                    : errorText != null
                        ? const BorderSide(color: BaseColor.red500, width: 1.0)
                        : const BorderSide(
                            color: BaseColor.green500, width: 2.0),
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(errorText,
                  style: BaseTextStyle.body2(
                      color: enable ? BaseColor.red500 : BaseColor.grey500)),
            )
        ]);
  }

  static Widget common(
      {required ValueChanged<String> onChanged,
      String? labelText,
      String? hintText,
      String? errorText,
      String? initialValue,
      bool required = false,
      bool enable = true,
      FocusNode? focusNode,
      TextEditingController? textEditingController,
      TextCapitalization textCapitalization = TextCapitalization.none,
      bool isObscured = false,
      bool autoFocus = false,
      int? maxLines,
      bool readOnly = false,
      TextInputAction? textInputAction,
      VoidCallback? onSuffixIconTap,
      VoidCallback? onPrefixIconTap,
      String? prefixIconPath,
      String? suffixIconPath,
      TextInputType? textInputType}) {
    return TextFieldWidget.base(
        onChanged: onChanged,
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        initialValue: initialValue,
        required: required,
        enable: enable,
        isObscured: isObscured,
        focusNode: focusNode,
        textEditingController: textEditingController,
        textCapitalization: textCapitalization,
        autoFocus: autoFocus,
        maxLines: maxLines,
        readOnly: readOnly,
        textInputAction: textInputAction,
        onPrefixIconTap: onPrefixIconTap,
        onSuffixIconTap: onSuffixIconTap,
        prefixIconPath: prefixIconPath,
        suffixIconPath: suffixIconPath,
        textInputType: textInputType);
  }

  static Widget otp({
    required ValueChanged<String> onChanged,
    required double size,
    String? initialValue,
    bool required = false,
    FocusNode? focusNode,
    bool enable = true,
    bool autoFocus = false,
    TextStyle? textStyle,
    TextEditingController? textEditingController,
    bool isObscured = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(boxShadow: [BaseShadowStyle.common]),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        onTap: () => textEditingController?.clear(),
        enabled: enable,
        obscureText: isObscured,
        cursorColor: BaseColor.green600,
        cursorWidth: 2,
        cursorHeight: 20,
        cursorRadius: const Radius.circular(2),
        showCursor: enable,
        style: enable
            ? textStyle ?? BaseTextStyle.body1()
            : BaseTextStyle.body1(color: BaseColor.grey500),
        focusNode: focusNode,
        controller: textEditingController,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        maxLines: 1,
        decoration: InputDecoration(
          counterText: "",
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 16,
            right: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
          ),
        ),
      ),
    );
  }

  static Widget search(
      {required ValueChanged<String> onChanged,
      String? labelText,
      String? initialValue,
      FocusNode? focusNode,
      Color? backgroundColor,
      TextEditingController? textEditingController,
      TextCapitalization textCapitalization = TextCapitalization.none,
      bool autoFocus = false,
      int? maxLines,
      VoidCallback? onSuffixIconTap,
      VoidCallback? onPrefixIconTap,
      TextInputType? textInputType}) {
    return TextFieldWidget.base(
        onChanged: onChanged,
        labelText: labelText,
        hintText: S.current.txt_search,
        initialValue: initialValue,
        focusNode: focusNode,
        textEditingController: textEditingController,
        textCapitalization: textCapitalization,
        autoFocus: autoFocus,
        maxLines: maxLines,
        isSearch: true,
        fillColor: backgroundColor ?? const Color(0xffEBEBEB),
        textInputAction: TextInputAction.search,
        onPrefixIconTap: onPrefixIconTap,
        onSuffixIconTap: onSuffixIconTap,
        prefixIconPath: IconPath.searchLine,
        suffixIconPath: (textEditingController != null &&
                textEditingController.text.isNotEmpty)
            ? IconPath.closeCircleLine
            : null,
        textInputType: textInputType);
  }

  static searchWhite(
      {required ValueChanged<String> onChanged,
      String? labelText,
      String? initialValue,
      FocusNode? focusNode,
      TextEditingController? textEditingController,
      TextCapitalization textCapitalization = TextCapitalization.none,
      bool autoFocus = false,
      int? maxLines,
      VoidCallback? onSuffixIconTap,
      VoidCallback? onPrefixIconTap,
      TextInputType? textInputType}) {
    return search(
        onChanged: onChanged,
        labelText: labelText,
        backgroundColor: Colors.white,
        initialValue: initialValue,
        focusNode: focusNode,
        textEditingController: textEditingController,
        textCapitalization: textCapitalization,
        autoFocus: autoFocus,
        maxLines: maxLines,
        onPrefixIconTap: onPrefixIconTap,
        onSuffixIconTap: onSuffixIconTap,
        textInputType: textInputType);
  }

  static dropdown(
      {required VoidCallback onTap,
      required BuildContext context,
      String? hintText,
      TextEditingController? controller,
      bool isDirect = false,
      String? prefixIconPath}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            TextFieldWidget.common(
                onChanged: (text) {},
                textEditingController: controller,
                prefixIconPath: prefixIconPath,
                suffixIconPath: isDirect ? IconPath.chevronDownLine : null,
                onSuffixIconTap: () {},
                hintText: hintText),
            Container(
              height: 48.0,
              width: MediaQuery.of(context).size.width - 32,
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
