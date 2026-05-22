class GuestUserBody {
  String? name;
  String? email;
  String? phone;
  String? countryCode;
  String? address;
  double? latitude;
  double? longitude;
  String? zipCode;
  String? addressType;
  String? street;

  GuestUserBody(
      {this.name,
      this.email,
      this.phone,
      this.address,
      this.latitude,
      this.longitude,
      this.zipCode,
      this.countryCode,
      this.addressType,
      this.street});

  toJson() => {
        'name': name,
        'email': email,
        'contact_number': "${countryCode?.trim()}${phone?.trim()}",
        'address': address,
        'type': addressType,
        'lat': latitude,
        'lang': longitude,
        'street': street,
        'zip_code': zipCode,
      };
}
