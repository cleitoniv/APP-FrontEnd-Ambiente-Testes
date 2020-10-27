class ExtratoFinanceiroModel {
  String date;
  List data;

  ExtratoFinanceiroModel({this.date, this.data});

  ExtratoFinanceiroModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {}
}
