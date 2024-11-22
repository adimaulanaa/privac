class SecurityProfileModel {
  String? password;
  String? fingerprint;

  SecurityProfileModel({
    this.password,
    this.fingerprint,
  });
}

class SecurityLogin {
  bool? check;
  int? isSecurity;

  SecurityLogin({
    this.check,
    this.isSecurity,
  });
}
