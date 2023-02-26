class PersonToken {
  String? token;

  PersonToken({
    this.token,
  });

  PersonToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}