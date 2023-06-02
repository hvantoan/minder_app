import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/domain/usecase/implement/language_usecase_impl.dart';
import 'package:minder/util/helper/language_helper.dart';

part 'base_layer_state.dart';

class BaseLayerCubit extends Cubit<BaseLayerState> {
  BaseLayerCubit() : super(BaseLayerInitialState()) {
    setupLanguage();
  }

  setupLanguage() async {
    Locale? currentLocale = await LanguageHelper.getCurrentLocale();
    String? languageKey = await LanguageUseCase().getLanguageKey();
    emit(LanguageState(currentLocale, languageKey));
  }

  changeLanguage({required BuildContext context, String? languageKey}) async {
    await LanguageUseCase().changeLanguage(languageKey: languageKey);
    setupLanguage();
  }
}
