import 'package:central_oftalmica_app_cliente/models/credit_model.dart';

class FinancialCreditModel {
  int id;
  int balance;
  List<CreditModel> credits;

  FinancialCreditModel({this.id, this.balance, this.credits});

  FinancialCreditModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
    if (json['credits'] != null) {
      credits = new List<CreditModel>();
      json['credits'].forEach((v) {
        credits.add(new CreditModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['balance'] = this.balance;
    if (this.credits != null) {
      data['credits'] = this.credits.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
