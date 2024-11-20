class UpdateSecurityModel {
  int? id;
  String? password;
  String? biomatricId;
  String? faceId;
  String? tokens;

  UpdateSecurityModel({
    this.id,
    this.password,
    this.biomatricId,
    this.faceId,
    this.tokens,
  });
}