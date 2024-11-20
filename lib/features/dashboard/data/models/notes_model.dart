import 'dart:convert';

class NotesModel {
  int? id;
  String? title;
  String? content;
  int? isPin;
  int? isLocked;
  String? password;
  String? biomatricId;
  String? faceId;
  String? tokens;
  int? createdId;
  DateTime? createdOn;
  String? createdBy;
  DateTime? updatedOn;
  String? updatedBy;
  bool isPassword;

  NotesModel({
    this.id,
    this.title,
    this.content,
    this.isPin,
    this.isLocked,
    this.password,
    this.biomatricId,
    this.faceId,
    this.tokens,
    this.createdId,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.isPassword = false,
  });

  // Convert a Breed into a Map. The keys must correspond to the titles of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'is_pin': isPin,
      'is_locked': isLocked,
      'password': password,
      'biomatric_id': biomatricId,
      'face_id': faceId,
      'tokens': tokens,
      'created_id': createdId,
      'created_on': createdOn.toString(),
      'created_by': createdBy,
      'updated_on': updatedOn.toString(),
      'updated_by': updatedBy,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      isPin: map['is_pin'] ?? 0,
      isLocked: map['is_locked'] ?? 0,
      password: map['password'] ?? '',
      biomatricId: map['biomatric_id'] ?? '',
      faceId: map['face_id'] ?? '',
      tokens: map['tokens'] ?? '',
      createdId: map['created_id'] ?? 0,
      createdOn: map['created_on'] != null ? DateTime.parse(map['created_on']) : null,
      createdBy: map['created_by'] ?? '',
      updatedOn: map['updated_on'] != null ? DateTime.parse(map['updated_on']) : null, 
      updatedBy: map['updated_by'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) => NotesModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'notes(_id: $id, title: $title, content: $content, is_pin: $isPin, is_locked: $isLocked, password: $password, biomatric_id: $biomatricId, face_id: $faceId, tokens: $tokens, created_id: $createdId, created_on: $createdOn, created_by: $createdBy, updated_on: $updatedOn, updated_by: $updatedBy)';
}
