import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/data/model/authentication/register_model.dart';

import 'debug.dart';

class DebugConfig {
  ///Mode
  /// TODO: Update when release
  static Mode mode = Mode.debug;

  ///Login (Auto fill)
  static LoginModel autoFillAccount = DebugData.debugAccount;

  ///Register (Auti=o fill)
  static RegisterModel autoFillRegisterAccount = DebugData.debugRegisterAccount;

  ///Print
  static bool printPageBuild = false;
  static bool printException = true;

  /// Fake Loading
  static bool fakeLoading = false;
}
