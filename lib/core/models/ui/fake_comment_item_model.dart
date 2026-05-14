class FakeCommentModel {
  final String userName;
  final String time;
  final String comment;
  final String? childrenComment;

  FakeCommentModel({
    required this.userName,
    required this.time,
    required this.comment,
    this.childrenComment,
  });
}
