import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/style/base_grid.dart';

class ScreenModeHelper {
  static Future<ScreenMode> getScreenModeByWidth(double width) async {
    if (width > maxTabletWidth) return ScreenMode.oversize;
    if (width > maxMobileWidth) return ScreenMode.tablet;
    return ScreenMode.mobile;
  }
}
