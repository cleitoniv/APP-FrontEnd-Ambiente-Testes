class TicketModel {
  String name;
  String subject;
  String message;
  String email;

  TicketModel({
    this.name,
    this.subject,
    this.message,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['subject'] = this.subject;
    data['message'] = this.message;
    return data;
  }

  static Future<TicketModel> fromJson(data) {
    return data;
  }
}
