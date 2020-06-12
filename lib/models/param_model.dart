class ParamModel {
  int sphericalDegree;
  int cylinder;
  int axis;

  ParamModel({this.sphericalDegree, this.cylinder, this.axis});

  ParamModel.fromJson(Map<String, dynamic> json) {
    sphericalDegree = json['spherical_degree'];
    cylinder = json['cylinder'];
    axis = json['axis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spherical_degree'] = this.sphericalDegree;
    data['cylinder'] = this.cylinder;
    data['axis'] = this.axis;
    return data;
  }
}
