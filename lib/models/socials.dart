/// message : "Successfully executed."
/// hasError : false
/// error : null
/// data : {"key":"a39cb8a7-fd2e-42ed-9207-e187c02e602e","url":"https://twitter.com/messages/compose?recipient_id=1273550785989804032&text=connect a39cb8a7-fd2e-42ed-9207-e187c02e602e"}

class Socials {
  Socials({
      String? message, 
      bool? hasError, 
      dynamic error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  Socials.fromJson(dynamic json) {
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

/// key : "a39cb8a7-fd2e-42ed-9207-e187c02e602e"
/// url : "https://twitter.com/messages/compose?recipient_id=1273550785989804032&text=connect a39cb8a7-fd2e-42ed-9207-e187c02e602e"

class Data {
  Data({
      String? key, 
      String? url,}){
    _key = key;
    _url = url;
}

  Data.fromJson(dynamic json) {
    _key = json['key'];
    _url = json['url'];
  }
  String? _key;
  String? _url;

  String? get key => _key;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = _key;
    map['url'] = _url;
    return map;
  }

}