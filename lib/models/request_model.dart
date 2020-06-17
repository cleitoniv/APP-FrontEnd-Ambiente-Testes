class RequestModel {
  int id;
  int value;
  String deliveryForecast;
  String requestDate;
  String status;
  String owner;

  RequestModel({
    this.id,
    this.value,
    this.deliveryForecast,
    this.requestDate,
    this.status,
    this.owner,
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    deliveryForecast = json['delivery_forecast'];
    requestDate = json['request_date'];
    status = json['status'];
    owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['delivery_forecast'] = this.deliveryForecast;
    data['request_date'] = this.requestDate;
    data['status'] = this.status;
    data['owner'] = this.owner;
    return data;
  }
}
