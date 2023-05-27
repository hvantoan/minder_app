class TokenModel {
  TokenModel(this._token, this._refreshToken);

  static TokenModel fromJson(dynamic json, [String? refreshToken]) {
    return TokenModel(json['token'], json['refreshToken'] ?? refreshToken);
  }

  final String _token;
  final String _refreshToken;

  String get token => _token;

  String get refreshToken => _refreshToken;
}
