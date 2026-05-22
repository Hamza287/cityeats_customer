class LocationBody {
  int? id;
  String? postalCode;
  double? lat;
  double? lng;
  String? streetAddress;
  String? name;
  String? label;
  String? fullAddress;

  LocationBody(
      {this.postalCode,
      this.id,
      this.lat,
      this.lng,
      this.streetAddress,
      this.name,
      this.label});

  LocationBody.fromJson(Map<String, dynamic> json) {
    id = json['address_id'];
    postalCode = json['zip_code'];
    lat = json['lat'];
    lng = json['lang'];
    streetAddress = json['address'];
    name = json['address'];
    label = json['type'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['address_id'] = id;
    data['zip_code'] = postalCode;
    data['lat'] = lat;
    data['lang'] = lng;
    data['address'] = "$name, $streetAddress";
    data['type'] = label;
    return data;
  }
}
