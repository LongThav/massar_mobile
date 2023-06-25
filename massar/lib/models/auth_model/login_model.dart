class LoginModel {
  String code;
  String message;
  Data data;

  LoginModel({
    this.code = "no-code",
    this.message = "no-message",
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String tokenType;
  String accessToken;
  User user;

  Data({
    this.tokenType = "no-tokenType",
    this.accessToken = "no-accessToken",
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        tokenType: json["token_type"],
        accessToken: json["access_token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "access_token": accessToken,
        "user": user.toJson(),
      };
}

class User {
  int id;
  String fullname;
  String email;
  bool click;
  String phone;
  String? image;
  String? address;
  String? verifyEmail;
  String? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.click = false,
    this.id = 0,
    this.fullname = "no-fullname",
    this.email = "no-email",
    this.phone = "no-phone",
    this.image,
    this.address,
    this.verifyEmail,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"] == null? null : json['image'],
        address: json["address"],
        verifyEmail: json["verify_email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "phone": phone,
        "image": image,
        "address": address,
        "verify_email": verifyEmail,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
