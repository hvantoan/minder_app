import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/language/language.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/base_layer/base_layer_cubit.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/path/image_path.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SheetWidget.title(
          context: context,
          title: S.current.lbl_language,
          submitContent: S.current.btn_done,
          onSubmit: () {
            Navigator.pop(context);
          }),
      Expanded(
        child: BlocBuilder<BaseLayerCubit, BaseLayerState>(
          builder: (context, state) {
            if (state is LanguageState) {
              return ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 32, left: 16, right: 16.0),
                  itemCount: Language.languages().length,
                  itemBuilder: (context, index) {
                    final Language language = Language.languages()[index];
                    return TileWidget.checkbox(
                        prefix: Image.asset(
                          language.imageIconPath,
                          width: 24.0,
                          height: 24.0,
                        ),
                        title: language.name,
                        isSelected: state.languageKey == language.key,
                        onChanged: (val) =>
                            changeLanguage(context: context, key: language.key),
                        onTap: () => changeLanguage(
                            context: context, key: language.key));
                  });
            }
            return ExceptionWidget(
              subContent: S.current.txt_data_parsing_failed,
              imagePath: ImagePath.dataParsingFailed,
              buttonContent: S.current.btn_try_again,
              onButtonTap: () =>
                  GetIt.instance.get<BaseLayerCubit>().setupLanguage(),
            );
          },
        ),
      ),
    ]);
  }

  Future<void> changeLanguage(
      {required BuildContext context, String? key}) async {
    await GetIt.instance
        .get<BaseLayerCubit>()
        .changeLanguage(context: context, languageKey: key);
    setState(() {});
  }
}
