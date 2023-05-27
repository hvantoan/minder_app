export 'package:minder/core/failures/common_failures.dart';

abstract class Failures {
  Failures({this.message});

  final String? message;
}
