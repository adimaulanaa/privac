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
  String? primaryKey;
  int? createdId;
  DateTime? createdOn;
  String? createdBy;
  DateTime? updatedOn;
  String? updatedBy;

  NotesModel({
    this.id,
    this.title,
    this.content,
    this.isPin,
    this.isLocked,
    this.password,
    this.biomatricId,
    this.faceId,
    this.primaryKey,
    this.createdId,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
  });

  // Convert a Breed into a Map. The keys must correspond to the titles of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'is_pin': isPin,
      'is_locked': isLocked,
      'password': password,
      'biomatric_id': biomatricId,
      'face_id': faceId,
      'primary_key': primaryKey,
      'created_id': createdId,
      'created_on': createdOn.toString(),
      'created_by': createdBy,
      'updated_on': updatedOn.toString(),
      'updated_by': updatedBy,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      isPin: map['is_pin'] ?? 0,
      isLocked: map['is_locked'] ?? 0,
      password: map['password'] ?? '',
      biomatricId: map['biomatric_id'] ?? '',
      faceId: map['face_id'] ?? '',
      primaryKey: map['primary_key'] ?? '',
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
  String toString() => 'notes(id: $id, title: $title, content: $content, is_pin: $isPin, is_locked: $isLocked, password: $password, biomatric_id: $biomatricId, face_id: $faceId, primary_key: $primaryKey, created_id: $createdId, created_on: $createdOn, created_by: $createdBy, updated_on: $updatedOn, updated_by: $updatedBy)';
}
