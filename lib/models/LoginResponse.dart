class LoginResponse {
  final String accessToken;
  final String tokenType;
  final User user;
  final int statusCode;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    required this.statusCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      user: User.fromJson(json['user']),
      statusCode: json['status_code'],
    );
  }
}

class User {
  final int id;
  final String? name;
  final String? email;
  final String phoneNumber;
  final String? gender;
  final String? dob;
  final String type;

  User({
    required this.id,
    this.name,
    this.email,
    required this.phoneNumber,
    this.gender,
    this.dob,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      dob: json['dob'],
      type: json['type'],
    );
  }
}
