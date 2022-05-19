import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email, password;
  String? pan, gstin, orgName, userName;

  UserModel(
      {required this.email,
      required this.password,
      this.pan,
      this.gstin,
      this.orgName,
      this.userName});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'pan': pan ?? '',
      'gstin': gstin ?? '',
      'org_name': orgName ?? '',
      'user_name': userName ?? '',
      'registered_on': Timestamp.now()
    };
  }
}
