class Message {
  String sender;
  String timestamp;
  String data;

  Message.fromJson(Map<String, dynamic> json)
      : sender = json['sender'],
        timestamp = json['timestamp'],
        data = json['message'];
}
