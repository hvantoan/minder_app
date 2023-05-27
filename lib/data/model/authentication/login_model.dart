class LoginModel {
  LoginModel(this._username, this._password);

  final String _username;
  final String _password;

  String? get username => _username;

  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }
}
