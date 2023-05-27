import 'package:minder/domain/entity/version/app_version.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionHelper {
  static Future<bool?> isSupportedVersion(AppVersion minimumVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppVersion? currentVersion = AppVersion.fromString(packageInfo.version);
    if (currentVersion == null) return null;
    if (currentVersion.major > minimumVersion.major) return true;
    if (currentVersion.major < minimumVersion.major) return false;
    if (currentVersion.minor > minimumVersion.minor) return true;
    if (currentVersion.minor < minimumVersion.minor) return false;
    if (currentVersion.patch < minimumVersion.patch) return false;
    return true;
  }
}
