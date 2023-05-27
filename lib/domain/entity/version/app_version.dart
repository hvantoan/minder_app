class AppVersion {
  AppVersion(this.major, this.minor, this.patch);

  late final int major;
  late final int minor;
  late final int patch;

  static AppVersion? fromString(String? version) {
    if (version == null || version.length > 8) return null;
    RegExp versionRegExp =
        RegExp(r'^([0-9][0-9]?)\.([0-9][0-9]?)\.([0-9][0-9]?)$');
    if (!versionRegExp.hasMatch(version)) return null;
    final result = versionRegExp.firstMatch(version);
    if (result == null ||
        result.group(1) == null ||
        result.group(2) == null ||
        result.group(3) == null) return null;
    return AppVersion(
      int.parse(result.group(1)!),
      int.parse(result.group(2)!),
      int.parse(result.group(3)!),
    );
  }

  static String toDisplayString(AppVersion appVersion) {
    return "${appVersion.major}.${appVersion.minor}.${appVersion.patch}";
  }
}
