class CreditModel {
  int id;
  int value;
  int parcels;

  CreditModel({this.id, this.value, this.parcels});

  CreditModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    parcels = json['parcels'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['parcels'] = this.parcels;
    return data;
  }
}
