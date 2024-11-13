// import 'dart:convert';

// class ProfileSaveModel {
//   int? id;
//   String? name;
//   String? username;
//   String? password;
//   String? biomatricId;
//   String? faceId;
//   String? primaryKey;
//   DateTime? createdOn;
//   String? createdBy;
//   DateTime? updatedOn;
//   String? updatedBy;

//   ProfileSaveModel({
//     this.id,
//     this.name,
//     this.username,
//     this.password,
//     this.biomatricId,
//     this.faceId,
//     this.primaryKey,
//     this.createdOn,
//     this.createdBy,
//     this.updatedOn,
//     this.updatedBy,
//   });

//   // Convert a Breed into a Map. The keys must correspond to the names of the
//   // columns in the database.
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'username': username,
//       'password': password,
//       'biomatric_id': biomatricId,
//       'face_id': faceId,
//       'primary_key': primaryKey,
//       'created_on': createdOn.toString(),
//       'created_by': createdBy,
//       'updated_on': updatedOn.toString(),
//       'updated_by': updatedBy,
//     };
//   }

//   factory ProfileSaveModel.fromMap(Map<String, dynamic> map) {
//     return ProfileSaveModel(
//       id: map['id']?.toInt() ?? 0,
//       name: map['name'] ?? '',
//       username: map['username'] ?? '',
//       password: map['password'] ?? '',
//       biomatricId: map['biomatric_id'] ?? '',
//       faceId: map['face_id'] ?? '',
//       primaryKey: map['primary_key'] ?? '',
//       createdOn: map['created_on'] != null ? DateTime.parse(map['created_on']) : null,
//       createdBy: map['created_by'] ?? '',
//       updatedOn: map['updated_on'] != null ? DateTime.parse(map['updated_on']) : null, 
//       updatedBy: map['updated_by'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ProfileSaveModel.fromJson(String source) => ProfileSaveModel.fromMap(json.decode(source));

//   // Implement toString to make it easier to see information about
//   // each breed when using the print statement.
//   @override
//   String toString() => 'user(id: $id, name: $name, username: $username, password: $password, biomatric_id: $biomatricId, face_id: $faceId, primary_key: $primaryKey, created_on: $createdOn, created_by: $createdBy, updated_on: $updatedOn, updated_by: $updatedBy)';
// }
