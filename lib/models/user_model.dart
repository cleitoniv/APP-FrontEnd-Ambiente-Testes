import 'package:central_oftalmica_app_cliente/models/locale_model.dart';

class UserModel {
  int id;
  String name;
  String cpf;
  String birthday;
  String email;
  String cellphone;
  String visitHour;
  String code;
  String dayOfSend;
  LocaleModel locale;

  UserModel({
    this.id,
    this.name,
    this.cpf,
    this.birthday,
    this.email,
    this.cellphone,
    this.visitHour,
    this.code,
    this.dayOfSend,
    this.locale,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cpf = json['cpf'];
    birthday = json['birthday'];
    email = json['email'];
    cellphone = json['cellphone'];
    visitHour = json['visit_hour'];
    code = json['code'];
    dayOfSend = json['day_of_send'];
    locale = json['locale'] != null
        ? new LocaleModel.fromJson(json['locale'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cpf'] = this.cpf;
    data['birthday'] = this.birthday;
    data['email'] = this.email;
    data['cellphone'] = this.cellphone;
    data['visit_hour'] = this.visitHour;
    data['code'] = this.code;
    data['day_of_send'] = this.dayOfSend;
    if (this.locale != null) {
      data['locale'] = this.locale.toJson();
    }
    return data;
  }
}
