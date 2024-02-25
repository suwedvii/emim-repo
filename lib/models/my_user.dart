// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

enum Gender { male, female, other }

class MyUser {
  String uuid;
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
  String contactPhysicalAddress;
  String contactPostalAddress;
  String nationality;
  String nokName;
  String relationshipWithNok;
  String nokContactNumber;
  String nokAddress;
  String nokPhysicalAddress;
  String nokTa;
  String nokDistrict;
  String nokSourceOfIncome;
  String userCampus;
  String userProgram;
  String userCohort;
  String yearOdStudy;
  String registeredSemester;
  String modeOfEntry;
  String modeOfStudy;

  MyUser(
      {this.profilePicture = 'N/A',
      this.uuid = 'N/A',
      this.userId = 'N/A',
      this.username = 'N/A',
      this.password = 'N/A',
      this.firstName = 'N/A',
      this.lastName = 'N/A',
      this.otherNames = 'N/A',
      this.role = 'N/A',
      this.dateOfBirth = 'N/A',
      this.idNumber = 'N/A',
      this.gender = 'N/A',
      this.title = 'N/A',
      this.contactNumber = 'N/A',
      this.emailAddress = 'N/A',
      this.creationDate = 'N/A',
      this.accountStatus = 'N/A',
      this.homeDistrict = 'N/A',
      this.homeTA = 'N/A',
      this.homeVillage = 'N/A',
      this.homeAddress = 'N/A',
      this.district = 'N/A',
      this.contactVillage = 'N/A',
      this.contactTA = 'N/A',
      this.contactDistrict = 'N/A',
      this.contactPhysicalAddress = 'N/A',
      this.contactPostalAddress = 'N/A',
      this.nationality = 'N/A',
      this.nokName = 'N/A',
      this.relationshipWithNok = 'N/A',
      this.nokContactNumber = 'N/A',
      this.nokAddress = 'N/A',
      this.nokPhysicalAddress = 'N/A',
      this.nokTa = 'N/A',
      this.nokDistrict = 'N/A',
      this.nokSourceOfIncome = 'N/A',
      this.userCampus = 'N/A',
      this.userProgram = 'N/A',
      this.userCohort = 'N/A',
      this.yearOdStudy = 'N/A',
      this.registeredSemester = 'N/A',
      this.modeOfEntry = 'N/A',
      this.modeOfStudy = 'N/A'});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
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
      'contactPhysicalAddress': contactPhysicalAddress,
      'contactPostalAddress': contactPostalAddress,
      'nationality': nationality,
      'nokName': nokName,
      'relationshipWithNok': relationshipWithNok,
      'nokContactNumber': nokContactNumber,
      'nokAddress': nokAddress,
      'nokPhysicalAddress': nokPhysicalAddress,
      'nokTa': nokTa,
      'nokDistrict': nokDistrict,
      'nokSourceOfIncome': nokSourceOfIncome,
      'userCampus': userCampus,
      'userProgram': userProgram,
      'userCohort': userCohort,
      'yearOdStudy': yearOdStudy,
      'registeredSemester': registeredSemester,
      'modeOfEntry': modeOfEntry,
      'modeOfStudy': modeOfStudy
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uuid: map['uuid'] as String,
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
      contactPhysicalAddress: map['contactPhysicalAddress'] as String,
      contactPostalAddress: map['contactPostalAddress'] as String,
      nationality: map['nationality'] as String,
      nokName: map['nokName'] as String,
      relationshipWithNok: map['relationshipWithNok'] as String,
      nokContactNumber: map['nokContactNumber'] as String,
      nokAddress: map['nokAddress'] as String,
      nokPhysicalAddress: map['nokPhysicalAddress'] as String,
      nokTa: map['nokTa'] as String,
      nokDistrict: map['nokDistrict'] as String,
      nokSourceOfIncome: map['nokSourceOfIncome'] as String,
      userCampus: map['userCampus'] as String,
      userProgram: map['userProgram'] as String,
      userCohort: map['userCohort'] as String,
      yearOdStudy: map['yearOdStudy'] as String,
      registeredSemester: map['registeredSemester'] as String,
      modeOfEntry: map['modeOfEntry'] as String,
      modeOfStudy: map['modeOfStudy'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) =>
      MyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  MyUser fromSnapshot(DataSnapshot snapshot) => MyUser(
        uuid: snapshot.child('id').value.toString(),
        profilePicture: snapshot.child('profilePicture').value.toString(),
        userId: snapshot.child('userId').value.toString(),
        username: snapshot.child('username').value.toString(),
        password: snapshot.child('password').value.toString(),
        firstName: snapshot.child('firstName').value.toString(),
        lastName: snapshot.child('lastName').value.toString(),
        otherNames: snapshot.child('otherNames').value.toString(),
        role: snapshot.child('role').value.toString(),
        dateOfBirth: snapshot.child('dateOfBirth').value.toString(),
        idNumber: snapshot.child('idNumber').value.toString(),
        gender: snapshot.child('gender').value.toString(),
        title: snapshot.child('title').value.toString(),
        contactNumber: snapshot.child('contactNumber').value.toString(),
        emailAddress: snapshot.child('emailAddress').value.toString(),
        creationDate: snapshot.child('creationDate').value.toString(),
        accountStatus: snapshot.child('accountStatus').value.toString(),
        homeDistrict: snapshot.child('homeDistrict').value.toString(),
        homeTA: snapshot.child('homeTA').value.toString(),
        homeVillage: snapshot.child('homeVillage').value.toString(),
        homeAddress: snapshot.child('homeAddress').value.toString(),
        district: snapshot.child('district').value.toString(),
        contactVillage: snapshot.child('contactVillage').value.toString(),
        contactTA: snapshot.child('contactTA').value.toString(),
        contactDistrict: snapshot.child('contactDistrict').value.toString(),
        contactPhysicalAddress:
            snapshot.child('contactPhysicalAddress').value.toString(),
        contactPostalAddress:
            snapshot.child('contactPostalAddress').value.toString(),
        nationality: snapshot.child('nationality').value.toString(),
        nokName: snapshot.child('nokName').value.toString(),
        relationshipWithNok:
            snapshot.child('relationshipWithNok').value.toString(),
        nokContactNumber: snapshot.child('nokContactNumber').value.toString(),
        nokAddress: snapshot.child('nokAddress').value.toString(),
        nokPhysicalAddress:
            snapshot.child('nokPhysicalAddress').value.toString(),
        nokTa: snapshot.child('nokTa').value.toString(),
        nokDistrict: snapshot.child('nokDistrict').value.toString(),
        nokSourceOfIncome: snapshot.child('nokSourceOfIncome').value.toString(),
        userCampus: snapshot.child('userCampus').value.toString(),
        userProgram: snapshot.child('userProgram').value.toString(),
        userCohort: snapshot.child('userCohort').value.toString(),
        yearOdStudy: snapshot.child('yearOdStudy').value.toString(),
        registeredSemester:
            snapshot.child('registeredSemester').value.toString(),
        modeOfEntry: snapshot.child('modeOfEntry').value.toString(),
        modeOfStudy: snapshot.child('modeOfStudy').value.toString(),
      );

  List<MyUser> getUsers(DatabaseReference userRef) {
    List<MyUser> users = [];

    userRef.onValue.listen((event) {
      for (final user in event.snapshot.children) {
        final retrievedUser = MyUser().fromSnapshot(user);
        users.add(retrievedUser);
      }
    });

    return users;
  }
}
