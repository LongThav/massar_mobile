class CommentModel {
  String message;
  int statusCode;
  UserComment user;

  CommentModel({
    this.message = "no-message",
    this.statusCode = 0,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        message: json["message"],
        statusCode: json["statusCode"],
        user: UserComment.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
        "user": user.toJson(),
      };
}

class UserComment {
  int id;
  String body;
  int userId;
  int postId;
  String? likeCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<UserComment> getAllComments;

  UserComment({
    this.id = 0,
    this.body = "no-body",
    this.userId = 0,
    this.postId = 0,
    this.likeCount = "no-likeCount",
    this.createdAt,
    this.updatedAt,
    this.getAllComments = const [],
  });

  factory UserComment.fromJson(Map<String, dynamic> json) => UserComment(
        id: json["id"],
        body: json["body"],
        userId: json["user_Id"],
        postId: json["post_id"],
        likeCount: json["like_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        getAllComments: json["get_all_comments"] == null
            ? []
            : List<UserComment>.from(
                json["get_all_comments"]!.map((x) => UserComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "user_Id": userId,
        "post_id": postId,
        "like_count": likeCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "get_all_comments": getAllComments == null
            ? []
            : List<dynamic>.from(getAllComments.map((x) => x.toJson())),
      };
}
