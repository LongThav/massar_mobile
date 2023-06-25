class RegisterModel {
  String message;
  int statusCode;
  User user;

  RegisterModel({
    this.message = "no-message",
    this.statusCode = 0,
    required this.user,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        message: json["message"],
        statusCode: json["statusCode"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
        "user": user.toJson(),
      };
}

class User {
  String fullname;
  String email;
  String phone;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  User({
    this.fullname = "no-fullname",
    this.email = "no-email",
    this.phone = "no-phone",
    required this.updatedAt,
    required this.createdAt,
    this.id = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullname: json["fullname"],
        email: json["email"],
        phone: json["phone"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "email": email,
        "phone": phone,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
