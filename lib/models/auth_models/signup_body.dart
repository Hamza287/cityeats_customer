class SignUpBody {
  String? email;
  String? password;
  String? fName;
  String? lName;
  String? phone;
  String? countryCode;

  /// Other fields to be added as well.
  SignUpBody({
    this.email,
    this.password,
    this.fName,
    this.lName,
    this.countryCode,
    this.phone,
  });

  toJson() {
    return {
      'name': "$fName $lName",
      'email': email,
      'contact_number': "${countryCode?.trim()}${phone?.trim()}",
      'password': password,
    };
  }

  toJsonForUpdate() {
    return {
      'name': "$fName",
      'email': email,
      'contact_number': phone,
    };
  }
}
