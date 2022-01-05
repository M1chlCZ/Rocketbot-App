/// message : "Processing error."
/// hasError : true
/// error : "User with this email exist."
/// data : null

class RegistrationError {
  RegistrationError({
      String? message, 
      bool? hasError, 
      String? error, 
      dynamic data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  RegistrationError.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'];
  }
  String? _message;
  bool? _hasError;
  String? _error;
  dynamic _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  dynamic get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    map['error'] = _error;
    map['data'] = _data;
    return map;
  }

}