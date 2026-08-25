import 'community_item_detail_model.dart';

class CommentOfPostResponseModel {
  CommentOfPostResponseModel({this.post, this.comments});

  final Post? post;
  final List<CommentModelOfPost>? comments;

  factory CommentOfPostResponseModel.fromJson(Map<String, dynamic> json) {
    return CommentOfPostResponseModel(
      post: json["post"] == null ? null : Post.fromJson(json["post"]),
      comments: json["comments"] == null
          ? []
          : List<CommentModelOfPost>.from(
              json["comments"]!.map((x) => CommentModelOfPost.fromJson(x)),
            ),
    );
  }
}

class CommentModelOfPost {
  CommentModelOfPost({
    this.id,
    this.creator,
    this.content,
    this.createdAt,
    this.replies,
  });

  final String? id;
  final Creator? creator;
  final String? content;
  final DateTime? createdAt;
  final List<ReplyModelOfPost>? replies;

  factory CommentModelOfPost.fromJson(Map<String, dynamic> json) {
    return CommentModelOfPost(
      id: json["_id"],
      creator: json["creator"] == null
          ? null
          : Creator.fromJson(json["creator"]),
      content: json["content"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      replies: json["replies"] == null
          ? []
          : List<ReplyModelOfPost>.from(
              json["replies"]!.map((x) => ReplyModelOfPost.fromJson(x)),
            ),
    );
  }
}

class ReplyModelOfPost {
  ReplyModelOfPost({this.id, this.creator, this.content, this.createdAt});

  final String? id;
  final Creator? creator;
  final String? content;
  final DateTime? createdAt;

  factory ReplyModelOfPost.fromJson(Map<String, dynamic> json) {
    return ReplyModelOfPost(
      id: json["_id"],
      creator: json["creator"] == null
          ? null
          : Creator.fromJson(json["creator"]),
      content: json["content"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }
}

class Post {
  Post({this.id, this.path, this.select});

  final String? id;
  final String? path;
  final String? select;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json["_id"], path: json["path"], select: json["select"]);
  }
}
