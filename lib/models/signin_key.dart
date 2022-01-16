/// message : "string"
/// hasError : true
/// error : "string"
/// data : {"loggedUser":{"user":{"id":0,"name":"string","surname":"string","email":"string","emailConfirmed":true,"partialAccount":true,"banned":true,"ban":{"userId":0,"active":true,"permanent":true,"experies":"2022-01-15T23:14:16.326Z","createdAt":"2022-01-15T23:14:16.326Z","reason":"string"},"roles":["string"],"socialMediaAccounts":[{"userId":0,"rocketAccountId":0,"name":"string","surname":"string","username":"string","avatarUrl":"string","socialMedia":1,"followers":0,"verefied":true,"registeredAt":"2022-01-15T23:14:16.326Z","mention":"string"}]},"token":"string","refreshToken":"string"},"expire":"2022-01-15T23:14:16.326Z","key":"3fa85f64-5717-4562-b3fc-2c963f66afa6","requireEmailCode":true,"requireSMSCode":true,"requireGoogle2faCode":true}

class SignKey {
  SignKey({
      String? message, 
      bool? hasError, 
      String? error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  SignKey.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  String? _error;
  Data? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// loggedUser : {"user":{"id":0,"name":"string","surname":"string","email":"string","emailConfirmed":true,"partialAccount":true,"banned":true,"ban":{"userId":0,"active":true,"permanent":true,"experies":"2022-01-15T23:14:16.326Z","createdAt":"2022-01-15T23:14:16.326Z","reason":"string"},"roles":["string"],"socialMediaAccounts":[{"userId":0,"rocketAccountId":0,"name":"string","surname":"string","username":"string","avatarUrl":"string","socialMedia":1,"followers":0,"verefied":true,"registeredAt":"2022-01-15T23:14:16.326Z","mention":"string"}]},"token":"string","refreshToken":"string"}
/// expire : "2022-01-15T23:14:16.326Z"
/// key : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// requireEmailCode : true
/// requireSMSCode : true
/// requireGoogle2faCode : true

class Data {
  Data({
      LoggedUser? loggedUser, 
      String? expire, 
      String? key, 
      bool? requireEmailCode, 
      bool? requireSMSCode, 
      bool? requireGoogle2faCode,}){
    _loggedUser = loggedUser;
    _expire = expire;
    _key = key;
    _requireEmailCode = requireEmailCode;
    _requireSMSCode = requireSMSCode;
    _requireGoogle2faCode = requireGoogle2faCode;
}

  Data.fromJson(dynamic json) {
    _loggedUser = json['loggedUser'] != null ? LoggedUser.fromJson(json['loggedUser']) : null;
    _expire = json['expire'];
    _key = json['key'];
    _requireEmailCode = json['requireEmailCode'];
    _requireSMSCode = json['requireSMSCode'];
    _requireGoogle2faCode = json['requireGoogle2faCode'];
  }
  LoggedUser? _loggedUser;
  String? _expire;
  String? _key;
  bool? _requireEmailCode;
  bool? _requireSMSCode;
  bool? _requireGoogle2faCode;

  LoggedUser? get loggedUser => _loggedUser;
  String? get expire => _expire;
  String? get key => _key;
  bool? get requireEmailCode => _requireEmailCode;
  bool? get requireSMSCode => _requireSMSCode;
  bool? get requireGoogle2faCode => _requireGoogle2faCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_loggedUser != null) {
      map['loggedUser'] = _loggedUser?.toJson();
    }
    map['expire'] = _expire;
    map['key'] = _key;
    map['requireEmailCode'] = _requireEmailCode;
    map['requireSMSCode'] = _requireSMSCode;
    map['requireGoogle2faCode'] = _requireGoogle2faCode;
    return map;
  }

}

/// user : {"id":0,"name":"string","surname":"string","email":"string","emailConfirmed":true,"partialAccount":true,"banned":true,"ban":{"userId":0,"active":true,"permanent":true,"experies":"2022-01-15T23:14:16.326Z","createdAt":"2022-01-15T23:14:16.326Z","reason":"string"},"roles":["string"],"socialMediaAccounts":[{"userId":0,"rocketAccountId":0,"name":"string","surname":"string","username":"string","avatarUrl":"string","socialMedia":1,"followers":0,"verefied":true,"registeredAt":"2022-01-15T23:14:16.326Z","mention":"string"}]}
/// token : "string"
/// refreshToken : "string"

class LoggedUser {
  LoggedUser({
      User? user, 
      String? token, 
      String? refreshToken,}){
    _user = user;
    _token = token;
    _refreshToken = refreshToken;
}

  LoggedUser.fromJson(dynamic json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _token = json['token'];
    _refreshToken = json['refreshToken'];
  }
  User? _user;
  String? _token;
  String? _refreshToken;

  User? get user => _user;
  String? get token => _token;
  String? get refreshToken => _refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['token'] = _token;
    map['refreshToken'] = _refreshToken;
    return map;
  }

}

/// id : 0
/// name : "string"
/// surname : "string"
/// email : "string"
/// emailConfirmed : true
/// partialAccount : true
/// banned : true
/// ban : {"userId":0,"active":true,"permanent":true,"experies":"2022-01-15T23:14:16.326Z","createdAt":"2022-01-15T23:14:16.326Z","reason":"string"}
/// roles : ["string"]
/// socialMediaAccounts : [{"userId":0,"rocketAccountId":0,"name":"string","surname":"string","username":"string","avatarUrl":"string","socialMedia":1,"followers":0,"verefied":true,"registeredAt":"2022-01-15T23:14:16.326Z","mention":"string"}]

class User {
  User({
      int? id, 
      String? name, 
      String? surname, 
      String? email, 
      bool? emailConfirmed, 
      bool? partialAccount, 
      bool? banned, 
      Ban? ban, 
      List<String>? roles, 
      List<SocialMediaAccounts>? socialMediaAccounts,}){
    _id = id;
    _name = name;
    _surname = surname;
    _email = email;
    _emailConfirmed = emailConfirmed;
    _partialAccount = partialAccount;
    _banned = banned;
    _ban = ban;
    _roles = roles;
    _socialMediaAccounts = socialMediaAccounts;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _surname = json['surname'];
    _email = json['email'];
    _emailConfirmed = json['emailConfirmed'];
    _partialAccount = json['partialAccount'];
    _banned = json['banned'];
    _ban = json['ban'] != null ? Ban.fromJson(json['ban']) : null;
    _roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    if (json['socialMediaAccounts'] != null) {
      _socialMediaAccounts = [];
      json['socialMediaAccounts'].forEach((v) {
        _socialMediaAccounts?.add(SocialMediaAccounts.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  String? _surname;
  String? _email;
  bool? _emailConfirmed;
  bool? _partialAccount;
  bool? _banned;
  Ban? _ban;
  List<String>? _roles;
  List<SocialMediaAccounts>? _socialMediaAccounts;

  int? get id => _id;
  String? get name => _name;
  String? get surname => _surname;
  String? get email => _email;
  bool? get emailConfirmed => _emailConfirmed;
  bool? get partialAccount => _partialAccount;
  bool? get banned => _banned;
  Ban? get ban => _ban;
  List<String>? get roles => _roles;
  List<SocialMediaAccounts>? get socialMediaAccounts => _socialMediaAccounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['surname'] = _surname;
    map['email'] = _email;
    map['emailConfirmed'] = _emailConfirmed;
    map['partialAccount'] = _partialAccount;
    map['banned'] = _banned;
    if (_ban != null) {
      map['ban'] = _ban?.toJson();
    }
    map['roles'] = _roles;
    if (_socialMediaAccounts != null) {
      map['socialMediaAccounts'] = _socialMediaAccounts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// userId : 0
/// rocketAccountId : 0
/// name : "string"
/// surname : "string"
/// username : "string"
/// avatarUrl : "string"
/// socialMedia : 1
/// followers : 0
/// verefied : true
/// registeredAt : "2022-01-15T23:14:16.326Z"
/// mention : "string"

class SocialMediaAccounts {
  SocialMediaAccounts({
      int? userId, 
      int? rocketAccountId, 
      String? name, 
      String? surname, 
      String? username, 
      String? avatarUrl, 
      int? socialMedia, 
      int? followers, 
      bool? verefied, 
      String? registeredAt, 
      String? mention,}){
    _userId = userId;
    _rocketAccountId = rocketAccountId;
    _name = name;
    _surname = surname;
    _username = username;
    _avatarUrl = avatarUrl;
    _socialMedia = socialMedia;
    _followers = followers;
    _verefied = verefied;
    _registeredAt = registeredAt;
    _mention = mention;
}

  SocialMediaAccounts.fromJson(dynamic json) {
    _userId = json['userId'];
    _rocketAccountId = json['rocketAccountId'];
    _name = json['name'];
    _surname = json['surname'];
    _username = json['username'];
    _avatarUrl = json['avatarUrl'];
    _socialMedia = json['socialMedia'];
    _followers = json['followers'];
    _verefied = json['verefied'];
    _registeredAt = json['registeredAt'];
    _mention = json['mention'];
  }
  int? _userId;
  int? _rocketAccountId;
  String? _name;
  String? _surname;
  String? _username;
  String? _avatarUrl;
  int? _socialMedia;
  int? _followers;
  bool? _verefied;
  String? _registeredAt;
  String? _mention;

  int? get userId => _userId;
  int? get rocketAccountId => _rocketAccountId;
  String? get name => _name;
  String? get surname => _surname;
  String? get username => _username;
  String? get avatarUrl => _avatarUrl;
  int? get socialMedia => _socialMedia;
  int? get followers => _followers;
  bool? get verefied => _verefied;
  String? get registeredAt => _registeredAt;
  String? get mention => _mention;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['rocketAccountId'] = _rocketAccountId;
    map['name'] = _name;
    map['surname'] = _surname;
    map['username'] = _username;
    map['avatarUrl'] = _avatarUrl;
    map['socialMedia'] = _socialMedia;
    map['followers'] = _followers;
    map['verefied'] = _verefied;
    map['registeredAt'] = _registeredAt;
    map['mention'] = _mention;
    return map;
  }

}

/// userId : 0
/// active : true
/// permanent : true
/// experies : "2022-01-15T23:14:16.326Z"
/// createdAt : "2022-01-15T23:14:16.326Z"
/// reason : "string"

class Ban {
  Ban({
      int? userId, 
      bool? active, 
      bool? permanent, 
      String? experies, 
      String? createdAt, 
      String? reason,}){
    _userId = userId;
    _active = active;
    _permanent = permanent;
    _experies = experies;
    _createdAt = createdAt;
    _reason = reason;
}

  Ban.fromJson(dynamic json) {
    _userId = json['userId'];
    _active = json['active'];
    _permanent = json['permanent'];
    _experies = json['experies'];
    _createdAt = json['createdAt'];
    _reason = json['reason'];
  }
  int? _userId;
  bool? _active;
  bool? _permanent;
  String? _experies;
  String? _createdAt;
  String? _reason;

  int? get userId => _userId;
  bool? get active => _active;
  bool? get permanent => _permanent;
  String? get experies => _experies;
  String? get createdAt => _createdAt;
  String? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['active'] = _active;
    map['permanent'] = _permanent;
    map['experies'] = _experies;
    map['createdAt'] = _createdAt;
    map['reason'] = _reason;
    return map;
  }

}