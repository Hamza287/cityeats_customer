class LoginBody {
  String? email;
  String? password;
  String? phone;
  bool isEmailSelected = false;

  LoginBody(
      {this.email, this.password, this.phone, this.isEmailSelected = false});

  toJson() => {
        'email': email,
        'password': password,
      };
}
