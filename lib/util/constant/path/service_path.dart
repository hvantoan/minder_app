class ServicePath {
  static const String serviceHost = "https://minder.toolseoviet.com/api";
  static const String hub = "https://minder.toolseoviet.com/hubs/chat";

  // static const String serviceHost = "https://localhost:8100/api";
  // static const String hub = "https://localhost:8100/hubs/chat";
  static const String appVersion = "$serviceHost/app-info/ver";

  //Register, Forgot
  static const String register = "$serviceHost/auth/register";
  static const String resendOTP = "$serviceHost/auth/resend";
  static const String verify = "$serviceHost/auth/verify";
  static const String forgotPassword = "$serviceHost/auth/forgot-password";

  //Token
  static const String login = "$serviceHost/auth/login";
  static const String refreshToken = "$serviceHost/auth/login/refresh";

  //Team
  static const String getTeam = "$serviceHost/teams";
  static const String postTeamList = "$serviceHost/teams/list";
  static const String saveTeam = "$serviceHost/teams/save";
  static const String kick = "kick";
  static const String leave = "leave";
  static const String invites = "$serviceHost/invites";
  static const String confirm = "confirm";
  static const String create = "create";
  static const String autoCal = "$serviceHost/teams/auto-cal";
  static const String suggestUser = "$serviceHost/teams/suggest-user";
  static const String suggestTeam = "$serviceHost/teams/suggest";
  static const String findTeam = "$serviceHost/teams/find";

  ///User
  static const String user = "$serviceHost/users";

  //Chat
  static const String message = "$serviceHost/messages";
  static const String sendMessage = "$serviceHost/messages/send-message";
  static const String saveUser = "$serviceHost/users/save";
  static const String listGroup = "$serviceHost/groups";
  static const String createGroup = "$serviceHost/groups/create";
  static const String updateGroup = "$serviceHost/groups/update";

  ///File
  static const String file = "$serviceHost/file/create";

  ///Stadium
  static const String stadium = "$serviceHost/stadium";
  static const String stadiumList = "list";
  static const String stadiumGet = "get";

  static String stadiumSuggest({required String matchId}) =>
      "$serviceHost/stadium/$matchId/suggest-for-match";

  ///Match
  static const String matches = "$serviceHost/matches";
  static const String swipe = "swipe-card";
  static const String selectTime = "selected-time";
  static const String selectStadium = "selected-stadium";
  static const String confirmSettingMatch = "confirm-setting-match";
  static const String addTimeOption = "add-time-opption";
  static const String memberConfirm = "member-confirm";
}
