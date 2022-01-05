/// message : "Successfully executed."
/// hasError : false
/// error : null
/// data : {"id":76295,"role":1,"name":"ladsfjlkadfj","surname":"aldjfklajfdl","email":"adlfjkadkls@lajkdflkajdsf.com","emailConfirmed":false,"partialAccount":false}

class RegistrationSucc {
  RegistrationSucc({
      String? message, 
      bool? hasError, 
      dynamic error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  RegistrationSucc.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  dynamic _error;
  Data? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  dynamic get error => _error;
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

/// id : 76295
/// role : 1
/// name : "ladsfjlkadfj"
/// surname : "aldjfklajfdl"
/// email : "adlfjkadkls@lajkdflkajdsf.com"
/// emailConfirmed : false
/// partialAccount : false

class Data {
  Data({
      int? id, 
      int? role, 
      String? name, 
      String? surname, 
      String? email, 
      bool? emailConfirmed, 
      bool? partialAccount,}){
    _id = id;
    _role = role;
    _name = name;
    _surname = surname;
    _email = email;
    _emailConfirmed = emailConfirmed;
    _partialAccount = partialAccount;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _role = json['role'];
    _name = json['name'];
    _surname = json['surname'];
    _email = json['email'];
    _emailConfirmed = json['emailConfirmed'];
    _partialAccount = json['partialAccount'];
  }
  int? _id;
  int? _role;
  String? _name;
  String? _surname;
  String? _email;
  bool? _emailConfirmed;
  bool? _partialAccount;

  int? get id => _id;
  int? get role => _role;
  String? get name => _name;
  String? get surname => _surname;
  String? get email => _email;
  bool? get emailConfirmed => _emailConfirmed;
  bool? get partialAccount => _partialAccount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['role'] = _role;
    map['name'] = _name;
    map['surname'] = _surname;
    map['email'] = _email;
    map['emailConfirmed'] = _emailConfirmed;
    map['partialAccount'] = _partialAccount;
    return map;
  }

}