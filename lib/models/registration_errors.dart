/// type : "https://tools.ietf.org/html/rfc7231#section-6.5.1"
/// title : "One or more validation errors occurred."
/// status : 400
/// traceId : "00-7cd37e16e4a29b41a0846c140a3f98be-e3347ea84189a242-00"
/// errors : {"Password":["Minimum length is 8 symbols"],"ConfirmPassword":["Minimum length is 8 symbols"]}

class RegistrationErrors {
  RegistrationErrors({
      String? type, 
      String? title, 
      int? status, 
      String? traceId, 
      Errors? errors,}){
    _type = type;
    _title = title;
    _status = status;
    _traceId = traceId;
    _errors = errors;
}

  RegistrationErrors.fromJson(dynamic json) {
    _type = json['type'];
    _title = json['title'];
    _status = json['status'];
    _traceId = json['traceId'];
    _errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
  String? _type;
  String? _title;
  int? _status;
  String? _traceId;
  Errors? _errors;

  String? get type => _type;
  String? get title => _title;
  int? get status => _status;
  String? get traceId => _traceId;
  Errors? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['title'] = _title;
    map['status'] = _status;
    map['traceId'] = _traceId;
    if (_errors != null) {
      map['errors'] = _errors?.toJson();
    }
    return map;
  }

}

/// Password : ["Minimum length is 8 symbols"]
/// ConfirmPassword : ["Minimum length is 8 symbols"]

class Errors {
  Errors({
      List<String>? password, 
      List<String>? confirmPassword,}){
    _password = password;
    _confirmPassword = confirmPassword;
}

  Errors.fromJson(dynamic json) {
    _password = json['Password'] != null ? json['Password'].cast<String>() : [];
    _confirmPassword = json['ConfirmPassword'] != null ? json['ConfirmPassword'].cast<String>() : [];
  }
  List<String>? _password;
  List<String>? _confirmPassword;

  List<String>? get password => _password;
  List<String>? get confirmPassword => _confirmPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Password'] = _password;
    map['ConfirmPassword'] = _confirmPassword;
    return map;
  }

}