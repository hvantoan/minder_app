import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/data/model/authentication/register_model.dart';
import 'package:minder/debug/debug.dart';

enum Mode { debug, release }

enum ServerAPIMethod { get, post, delete }

class DebugData {
  /// Timeout
  static Duration fakeLoadingDuration = Duration(
      seconds:
          (DebugConfig.fakeLoading && DebugConfig.mode == Mode.debug) ? 5 : 0);

  /// Test Account
  static LoginModel debugAccount =
      LoginModel("toan01473@gmail.com", "12345678");

  /// Test register Account
  static RegisterModel debugRegisterAccount = RegisterModel(
    "Văn Toàn",
    "toan01473@gmail.com",
    "12345678",
    "0336516906",
  );
}
