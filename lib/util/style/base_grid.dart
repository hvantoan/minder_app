import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/helper/screen_mode_helper.dart';

final BaseGrid instanceBaseGrid = BaseGrid();

const maxMobileWidth = 500;
const maxTabletWidth = 800;

class BaseGrid {
  ScreenMode screenMode = ScreenMode.mobile;
  double margin = 16;
  double gutter = 16;

  Future<void> init(double width) async {
    screenMode = await ScreenModeHelper.getScreenModeByWidth(width);
    switch (screenMode) {
      case ScreenMode.mobile:
        margin = 16;
        gutter = 16;
        break;
      case ScreenMode.tablet:
        margin = 32;
        gutter = 32;
        break;
      case ScreenMode.oversize:
        margin = await getOverMargin(width);
        gutter = 32;
        break;
    }
  }

  static Future<double> getOverMargin(double width) async {
    if (instanceBaseGrid.screenMode != ScreenMode.oversize) return 0;
    double overMargin = (width - maxTabletWidth) / 2;
    return overMargin;
  }
}
