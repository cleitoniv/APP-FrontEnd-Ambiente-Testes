class Details {
  String description;
  String material;
  int dkt;
  bool vistint;
  int thickness;
  int hydration;
  String assepsis;
  String discard;
  String design;
  int diameter;
  int baseCurve;
  List<int> spherical;

  Details({
    this.description,
    this.material,
    this.dkt,
    this.vistint,
    this.thickness,
    this.hydration,
    this.assepsis,
    this.discard,
    this.design,
    this.diameter,
    this.baseCurve,
    this.spherical,
  });

  Details.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    material = json['material'];
    dkt = json['dkt'];
    vistint = json['vistint'];
    thickness = json['thickness'];
    hydration = json['hydration'];
    assepsis = json['assepsis'];
    discard = json['discard'];
    design = json['design'];
    diameter = json['diameter'];
    baseCurve = json['base_curve'];
    spherical = json['spherical'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['material'] = this.material;
    data['dkt'] = this.dkt;
    data['vistint'] = this.vistint;
    data['thickness'] = this.thickness;
    data['hydration'] = this.hydration;
    data['assepsis'] = this.assepsis;
    data['discard'] = this.discard;
    data['design'] = this.design;
    data['diameter'] = this.diameter;
    data['base_curve'] = this.baseCurve;
    data['spherical'] = this.spherical;
    return data;
  }
}
