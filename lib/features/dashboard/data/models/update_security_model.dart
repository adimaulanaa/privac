class UpdateSecurityModel {
  String? id;
  String? password;
  String? biomatricId;
  String? faceId;
  String? fingerprintId;
  String? tokens;

  UpdateSecurityModel({
    this.id,
    this.password,
    this.biomatricId,
    this.faceId,
    this.fingerprintId,
    this.tokens,
  });
}