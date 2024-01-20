// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum Gender { male, female, other }

enum Titles { mr, ms, mrs, prof, dr, sir }

class MyUser {
  String profilePicture;
  String userId;
  String username;
  String password;
  String firstName;
  String lastName;
  String otherNames;
  String role;
  String dateOfBirth;
  String idNumber;
  String gender;
  String title;
  String contactNumber;
  String emailAddress;
  String creationDate;
  String accountStatus;
  String homeDistrict;
  String homeTA;
  String homeVillage;
  String homeAddress;
  String district;
  String contactVillage;
  String contactTA;
  String contactDistrict;
  String contactAddress;
  String nationality;
  String nokName;
  String relationshipWithNok;
  String nokContactNumber;
  String nokAddress;
  String nokSourceOfIncome;

  MyUser({
    this.profilePicture = '',
    required this.userId,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.otherNames,
    required this.role,
    this.dateOfBirth = '',
    this.idNumber = '',
    this.gender = '',
    this.title = '',
    this.contactNumber = '',
    this.emailAddress = '',
    this.creationDate = '',
    this.accountStatus = '',
    this.homeDistrict = '',
    this.homeTA = '',
    this.homeVillage = '',
    this.homeAddress = '',
    this.district = '',
    this.contactVillage = '',
    this.contactTA = '',
    this.contactDistrict = '',
    this.contactAddress = '',
    this.nationality = '',
    this.nokName = '',
    this.relationshipWithNok = '',
    this.nokContactNumber = '',
    this.nokAddress = '',
    this.nokSourceOfIncome = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profilePicture': profilePicture,
      'userId': userId,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'otherNames': otherNames,
      'role': role,
      'dateOfBirth': dateOfBirth,
      'idNumber': idNumber,
      'gender': gender,
      'title': title,
      'contactNumber': contactNumber,
      'emailAddress': emailAddress,
      'creationDate': creationDate,
      'accountStatus': accountStatus,
      'homeDistrict': homeDistrict,
      'homeTA': homeTA,
      'homeVillage': homeVillage,
      'homeAddress': homeAddress,
      'district': district,
      'contactVillage': contactVillage,
      'contactTA': contactTA,
      'contactDistrict': contactDistrict,
      'contactAddress': contactAddress,
      'nationality': nationality,
      'nokName': nokName,
      'relationshipWithNok': relationshipWithNok,
      'nokContactNumber': nokContactNumber,
      'nokAddress': nokAddress,
      'nokSourceOfIncome': nokSourceOfIncome,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      profilePicture: map['profilePicture'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      otherNames: map['otherNames'] as String,
      role: map['role'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      idNumber: map['idNumber'] as String,
      gender: map['gender'] as String,
      title: map['title'] as String,
      contactNumber: map['contactNumber'] as String,
      emailAddress: map['emailAddress'] as String,
      creationDate: map['creationDate'] as String,
      accountStatus: map['accountStatus'] as String,
      homeDistrict: map['homeDistrict'] as String,
      homeTA: map['homeTA'] as String,
      homeVillage: map['homeVillage'] as String,
      homeAddress: map['homeAddress'] as String,
      district: map['district'] as String,
      contactVillage: map['contactVillage'] as String,
      contactTA: map['contactTA'] as String,
      contactDistrict: map['contactDistrict'] as String,
      contactAddress: map['contactAddress'] as String,
      nationality: map['nationality'] as String,
      nokName: map['nokName'] as String,
      relationshipWithNok: map['relationshipWithNok'] as String,
      nokContactNumber: map['nokContactNumber'] as String,
      nokAddress: map['nokAddress'] as String,
      nokSourceOfIncome: map['nokSourceOfIncome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) =>
      MyUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
