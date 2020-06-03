class LocaleModel {
  String zipCode;
  String address;
  String number;
  String adjunct;
  String district;
  String city;

  LocaleModel({
    this.zipCode,
    this.address,
    this.number,
    this.adjunct,
    this.district,
    this.city,
  });

  LocaleModel.fromJson(Map<String, dynamic> json) {
    zipCode = json['zip_code'];
    address = json['address'];
    number = json['number'];
    adjunct = json['adjunct'];
    district = json['district'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zip_code'] = this.zipCode;
    data['address'] = this.address;
    data['number'] = this.number;
    data['adjunct'] = this.adjunct;
    data['district'] = this.district;
    data['city'] = this.city;
    return data;
  }
}
