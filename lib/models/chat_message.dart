class ChatMessage{

  int id;
  int userId;
  String message;
  int sender;
  int userReadStatus;
  int adminReadStatus;
  String image;
  String record;
  String sendAt;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.message,
    required this.sender,
    required this.userReadStatus,
    required this.adminReadStatus,
    required this.image,
    required this.record,
    required this.sendAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json){
    return ChatMessage(
      id: json['id'] as int,
      userId: json['user_id'],
      message: json['message'],
      sender: json['sender'],
      userReadStatus: json['user_read_status'],
      adminReadStatus: json['admin_read_status'],
      image: json['image'].toString(),
      record: json['record'].toString(),
      sendAt: json['created_at'].toString(),
    );
  }
}