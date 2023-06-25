class PostModel {
    String message;
    int statusCode;
    Post data;

    PostModel({
         this.message = "no-message", 
         this.statusCode = 0,
         required this.data,
    });

    factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        message: json["message"],
        statusCode: json["statusCode"],
        data: Post.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
        "data": data.toJson(),
    };
}

class Post {
    int id;
    String image;
    String description;
    User user;
    List<Comment> comments;
    int like;

    Post({
         this.id = 0,
         this.image = "no-image",
         this.description = "no-description",
         required this.user,
         this.comments = const [],
         this.like = 0,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        image: json["image"],
        description: json["description"],
        user: User.fromJson(json["user"]),
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
        like: json["like"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "description": description,
        "user": user.toJson(),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "like": like,
    };
}

class Comment {
    int id;
    String body;
    int userId;
    int postId;
    String? likeCount;
    DateTime createdAt;
    DateTime updatedAt;

    Comment({
        this.id = 0,
        this.body = "no-body",
        this.userId = 0,
        this.postId = 0,
        this.likeCount,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        body: json["body"],
        userId: json["user_Id"],
        postId: json["post_id"],
        likeCount: json["like_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "user_Id": userId,
        "post_id": postId,
        "like_count": likeCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class User {
    int id;
    String fullname;
    String email;
    String phone;
    String? userId;
    String? image;
    String? address;
    String? verifyEmail;
    String? emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({
        this.id = 0,
        this.fullname = "no-fullname",
        this.email = "no-email",
        this.phone =  "no-phone",
        this.userId = "no-userId",
        this.image = "no-image",
        this.address = "no-address",
        this.verifyEmail = "no-verifyEmail",
        this.emailVerifiedAt = "no-emailVerifiedAt",
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        phone: json["phone"],
        userId: json["user_id"],
        image: json["image"] ?? "noImage",
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
