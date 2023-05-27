import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/base_layer/base_layer_cubit.dart';
import 'package:minder/presentation/widget/bottom_sheet_component/date_bottom_sheet.dart';
import 'package:minder/presentation/widget/bottom_sheet_component/language_bottom_sheet.dart';
import 'package:minder/presentation/widget/bottom_sheet_component/sex_bottom_sheet.dart';
import 'package:minder/presentation/widget/bottom_sheet_component/stadium_type_bottom_sheet.dart';
import 'package:minder/util/constant/enum/gender_enum.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/gender_helper.dart';

class BottomSheetComponents {
  static Future<void> settingLanguage({
    required BuildContext context,
    required Function(String) onSuccess,
  }) {
    var languages = [
      {
        "name": S.current.txt_system_language,
        "imagePath": ImagePath.device,
        "key": ""
      },
      {"name": "Tiếng việt", "imagePath": ImagePath.vietnamese, "key": "vi"},
      {"name": "English", "imagePath": ImagePath.english, "key": "en"}
    ];

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return BlocBuilder<BaseLayerCubit, BaseLayerState>(
          builder: (context, state) {
            if (state is LanguageState) {
              return LanguageSetting(
                onSuccess: onSuccess,
                context: context,
                languages: languages,
                languageKey: state.languageKey ?? "",
              );
            }

            return Column(
              children: List.generate(3, (index) => Container(height: 48)),
            );
          },
        );
      },
    );
  }

  static Future<void> settingStadiumType({
    required BuildContext context,
    required Function(List<int>) onSuccess,
    required List<int> types,
  }) {
    final stadiumTypes = [
      {"index": 5, "name": "${S.current.lbl_stadium} 5"},
      {"index": 7, "name": "${S.current.lbl_stadium} 7"},
      {"index": 11, "name": "${S.current.lbl_stadium} 11"}
    ];

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return StadiumTypeSetting(
          onSuccess: onSuccess,
          context: context,
          stadiumTypes: stadiumTypes,
          types: types,
        );
      },
    );
  }

  static Future<void> settingSex({
    required BuildContext context,
    required Function(int) onSuccess,
    required int value,
  }) {
    final sexs = [
      {
        "value": 0,
        "name": GenderHelper.mapKeyToName(Gender.male),
        "imagePath": ImagePath.male
      },
      {
        "value": 1,
        "name": GenderHelper.mapKeyToName(Gender.female),
        "imagePath": ImagePath.female
      },
      {
        "value": 2,
        "name": GenderHelper.mapKeyToName(Gender.different),
        "imagePath": ImagePath.different
      }
    ];

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return SexSetting(
          onSuccess: onSuccess,
          context: context,
          sexs: sexs,
          value: value,
        );
      },
    );
  }

  static Future<void> settingDOB({
    required BuildContext context,
    required Function(DateTime?) onSuccess,
    DateTime? dob,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return DateBottomSheet(
          dob: dob,
          onSuccess: onSuccess,
        );
      },
    );
  }
}
