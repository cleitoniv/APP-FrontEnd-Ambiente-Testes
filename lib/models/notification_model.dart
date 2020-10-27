class NotificationModel {
  int id;
  bool isRead;
  String title;
  String subtitle;
  String date;
  String type;

  NotificationModel({
    this.id,
    this.isRead,
    this.title,
    this.subtitle,
    this.date,
    this.type,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRead = json['lido'];
    title = json['title'];
    subtitle = json['mensagem'];
    date = json['data'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_read'] = this.isRead;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['date'] = this.date;
    data['type'] = this.type;
    return data;
  }
}
