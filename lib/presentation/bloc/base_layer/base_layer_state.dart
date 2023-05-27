part of 'base_layer_cubit.dart';

abstract class BaseLayerState {}

class BaseLayerInitialState extends BaseLayerState {}

class LanguageState extends BaseLayerState {
  LanguageState(this.locale, this.languageKey);

  final dynamic locale;
  final dynamic languageKey;

  List<Object> get props => [locale, languageKey];
}
