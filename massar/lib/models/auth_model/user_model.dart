class AllUserModel {
    String message;
    int statusCode;
    List<UserModel> data;

    AllUserModel({
         this.message = "no-message",
         this.statusCode = 0,
         this.data = const [],
    });

    factory AllUserModel.fromJson(Map<String, dynamic> json) => AllUserModel(
        message: json["message"],
        statusCode: json["statusCode"],
        data: List<UserModel>.from(json["data"].map((x) => UserModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class UserModel {
    int id;
    String fullname;
    String email;
    String phone;
    String? userId;
    String image;
    String? address;
    bool checkSent;
    String? verifyEmail;
    String? emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    UserModel({
      this.checkSent = false,
        this.id = 0,
        this.fullname = "no-fullname",
        this.email = "no-email",
        this.phone = "no-phone",
        this.userId = "userId",
        this.image = "no-image",
        this.address = "no-address",
        this.verifyEmail = "no-verifyEmail",
        this.emailVerifiedAt = "no-emailVerifiedAt",
        this.createdAt,
        this.updatedAt,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        phone: json["phone"],
        userId: json["user_id"],
        image: json["image"],
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
        "user_id": userId,
        "image": image,
        "address": address,
        "verify_email": verifyEmail,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
