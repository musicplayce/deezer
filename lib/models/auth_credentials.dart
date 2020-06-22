class AuthCredentials {
  String accessToken;
  int expires;

  AuthCredentials({this.accessToken, this.expires});

  AuthCredentials.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expires = json['expires'] is String ? int.parse(json['expires']) : json['expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires'] = this.expires;
    return data;
  }
}