class MessageModel {
  String message, userId, userName;
  String? userImage;
  bool isRead, isAlert;

  MessageModel(
      {this.userId = "",
      this.message = "",
      this.isRead = false,
      this.userName = "",
      this.userImage,
      this.isAlert = false});
}
