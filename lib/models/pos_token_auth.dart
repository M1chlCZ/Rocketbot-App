/// account : "already added"
/// hasError : false
/// refresh_token : "b736791b3616ba5006d14279a8e3f8dbfbae41f5dd99d25ca25b2b87052e49ec"
/// status : "OK"
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2NDY0MzcyODQsImlkVXNlciI6Njg4NTd9.hycR3kkQbDVZT3DQANotKxBOF1x05u8MgatLLiil9vE"

class PosTokenAuth {
  PosTokenAuth({
      String? account, 
      bool? hasError, 
      String? refreshToken, 
      String? status, 
      String? token,}){
    _account = account;
    _hasError = hasError;
    _refreshToken = refreshToken;
    _status = status;
    _token = token;
}

  PosTokenAuth.fromJson(dynamic json) {
    _account = json['account'];
    _hasError = json['hasError'];
    _refreshToken = json['refresh_token'];
    _status = json['status'];
    _token = json['token'];
  }
  String? _account;
  bool? _hasError;
  String? _refreshToken;
  String? _status;
  String? _token;

  String? get account => _account;
  bool? get hasError => _hasError;
  String? get refreshToken => _refreshToken;
  String? get status => _status;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['account'] = _account;
    map['hasError'] = _hasError;
    map['refresh_token'] = _refreshToken;
    map['status'] = _status;
    map['token'] = _token;
    return map;
  }

}