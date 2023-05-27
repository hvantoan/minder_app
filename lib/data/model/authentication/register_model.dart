class RegisterModel {
  RegisterModel(this._name, this._username, this._password, this._phone);

  final String _name;
  final String _username;
  final String _password;
  final String _phone;

  String? get name => _name;
  String? get username => _username;
  String? get password => _password;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['username'] = _username;
    map['password'] = _password;
    map['phone'] = _phone;
    return map;
  }
}
