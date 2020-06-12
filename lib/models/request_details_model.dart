import 'package:central_oftalmica_app_cliente/models/param_model.dart';

class RequestDetailsModel {
  int id;
  int value;
  String deliveryForecast;
  String requestDate;
  String lastRequest;
  String status;
  String owner;
  int referenceId;
  String birthday;
  int productId;
  String adviceTime;
  int quantity;
  String type;
  ParamModel leftEye;
  ParamModel rightEye;

  RequestDetailsModel({
    this.id,
    this.value,
    this.deliveryForecast,
    this.requestDate,
    this.status,
    this.owner,
    this.referenceId,
    this.birthday,
    this.productId,
    this.adviceTime,
    this.quantity,
    this.lastRequest,
    this.leftEye,
    this.rightEye,
    this.type,
  });

  RequestDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    deliveryForecast = json['delivery_forecast'];
    requestDate = json['request_date'];
    status = json['status'];
    owner = json['owner'];
    referenceId = json['reference_id'];
    birthday = json['birthday'];
    productId = json['product_id'];
    adviceTime = json['advice_time'];
    lastRequest = json['last_request'];
    quantity = json['quantity'];
    type = json['type'];
    leftEye = json['left_eye'] != null
        ? new ParamModel.fromJson(json['left_eye'])
        : null;
    rightEye = json['right_eye'] != null
        ? new ParamModel.fromJson(json['right_eye'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['delivery_forecast'] = this.deliveryForecast;
    data['request_date'] = this.requestDate;
    data['status'] = this.status;
    data['owner'] = this.owner;
    data['reference_id'] = this.referenceId;
    data['birthday'] = this.birthday;
    data['product_id'] = this.productId;
    data['advice_time'] = this.adviceTime;
    data['last_request'] = this.lastRequest;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    if (this.leftEye != null) {
      data['left_eye'] = this.leftEye.toJson();
    }
    if (this.rightEye != null) {
      data['right_eye'] = this.rightEye.toJson();
    }
    return data;
  }
}
