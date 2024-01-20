import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Staff {
  String? profilePicture;
  String? userId;
  String? username;
  String? firstName;
  String? lastName;
  String? otherNames;
  String? role;
  String? dateOfBirth;
  String? idNumber;
  String? gender;
  String? title;
  String? contactNumber;
  String? emailAddress;
  String? creationDate;
  String? accountStatus;
  String? homeDistrict;
  String? homeTA;
  String? homeVillage;
  String? homeAddress;
  String? district;
  String? contactVillage;
  String? contactTA;
  String? contactDistrict;
  String? contactAddress;
  String? nationality;
  String? nokName;
  String? relationshipWithNok;
  String? nokContactNumber;
  String? nokAddress;
  String? nokSourceOfIncome;
  Staff({
    this.profilePicture,
    this.userId,
    this.username,
    this.firstName,
    this.lastName,
    this.otherNames,
    this.role,
    this.dateOfBirth,
    this.idNumber,
    this.gender,
    this.title,
    this.contactNumber,
    this.emailAddress,
    this.creationDate,
    this.accountStatus,
    this.homeDistrict,
    this.homeTA,
    this.homeVillage,
    this.homeAddress,
    this.district,
    this.contactVillage,
    this.contactTA,
    this.contactDistrict,
    this.contactAddress,
    this.nationality,
    this.nokName,
    this.relationshipWithNok,
    this.nokContactNumber,
    this.nokAddress,
    this.nokSourceOfIncome,
  });

  Staff copyWith({
    String? profilePicture,
    String? userId,
    String? username,
    String? firstName,
    String? lastName,
    String? otherNames,
    String? role,
    String? dateOfBirth,
    String? idNumber,
    String? gender,
    String? title,
    String? contactNumber,
    String? emailAddress,
    String? creationDate,
    String? accountStatus,
    String? homeDistrict,
    String? homeTA,
    String? homeVillage,
    String? homeAddress,
    String? district,
    String? contactVillage,
    String? contactTA,
    String? contactDistrict,
    String? contactAddress,
    String? nationality,
    String? nokName,
    String? relationshipWithNok,
    String? nokContactNumber,
    String? nokAddress,
    String? nokSourceOfIncome,
  }) {
    return Staff(
      profilePicture: profilePicture ?? this.profilePicture,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      otherNames: otherNames ?? this.otherNames,
      role: role ?? this.role,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      idNumber: idNumber ?? this.idNumber,
      gender: gender ?? this.gender,
      title: title ?? this.title,
      contactNumber: contactNumber ?? this.contactNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      creationDate: creationDate ?? this.creationDate,
      accountStatus: accountStatus ?? this.accountStatus,
      homeDistrict: homeDistrict ?? this.homeDistrict,
      homeTA: homeTA ?? this.homeTA,
      homeVillage: homeVillage ?? this.homeVillage,
      homeAddress: homeAddress ?? this.homeAddress,
      district: district ?? this.district,
      contactVillage: contactVillage ?? this.contactVillage,
      contactTA: contactTA ?? this.contactTA,
      contactDistrict: contactDistrict ?? this.contactDistrict,
      contactAddress: contactAddress ?? this.contactAddress,
      nationality: nationality ?? this.nationality,
      nokName: nokName ?? this.nokName,
      relationshipWithNok: relationshipWithNok ?? this.relationshipWithNok,
      nokContactNumber: nokContactNumber ?? this.nokContactNumber,
      nokAddress: nokAddress ?? this.nokAddress,
      nokSourceOfIncome: nokSourceOfIncome ?? this.nokSourceOfIncome,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profilePicture': profilePicture,
      'userId': userId,
      'username': username,
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

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      otherNames:
          map['otherNames'] != null ? map['otherNames'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      dateOfBirth:
          map['dateOfBirth'] != null ? map['dateOfBirth'] as String : null,
      idNumber: map['idNumber'] != null ? map['idNumber'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      contactNumber:
          map['contactNumber'] != null ? map['contactNumber'] as String : null,
      emailAddress:
          map['emailAddress'] != null ? map['emailAddress'] as String : null,
      creationDate:
          map['creationDate'] != null ? map['creationDate'] as String : null,
      accountStatus:
          map['accountStatus'] != null ? map['accountStatus'] as String : null,
      homeDistrict:
          map['homeDistrict'] != null ? map['homeDistrict'] as String : null,
      homeTA: map['homeTA'] != null ? map['homeTA'] as String : null,
      homeVillage:
          map['homeVillage'] != null ? map['homeVillage'] as String : null,
      homeAddress:
          map['homeAddress'] != null ? map['homeAddress'] as String : null,
      district: map['district'] != null ? map['district'] as String : null,
      contactVillage: map['contactVillage'] != null
          ? map['contactVillage'] as String
          : null,
      contactTA: map['contactTA'] != null ? map['contactTA'] as String : null,
      contactDistrict: map['contactDistrict'] != null
          ? map['contactDistrict'] as String
          : null,
      contactAddress: map['contactAddress'] != null
          ? map['contactAddress'] as String
          : null,
      nationality:
          map['nationality'] != null ? map['nationality'] as String : null,
      nokName: map['nokName'] != null ? map['nokName'] as String : null,
      relationshipWithNok: map['relationshipWithNok'] != null
          ? map['relationshipWithNok'] as String
          : null,
      nokContactNumber: map['nokContactNumber'] != null
          ? map['nokContactNumber'] as String
          : null,
      nokAddress:
          map['nokAddress'] != null ? map['nokAddress'] as String : null,
      nokSourceOfIncome: map['nokSourceOfIncome'] != null
          ? map['nokSourceOfIncome'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) =>
      Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Staff(profilePicture: $profilePicture, userId: $userId, username: $username, firstName: $firstName, lastName: $lastName, otherNames: $otherNames, role: $role, dateOfBirth: $dateOfBirth, idNumber: $idNumber, gender: $gender, title: $title, contactNumber: $contactNumber, emailAddress: $emailAddress, creationDate: $creationDate, accountStatus: $accountStatus, homeDistrict: $homeDistrict, homeTA: $homeTA, homeVillage: $homeVillage, homeAddress: $homeAddress, district: $district, contactVillage: $contactVillage, contactTA: $contactTA, contactDistrict: $contactDistrict, contactAddress: $contactAddress, nationality: $nationality, nokName: $nokName, relationshipWithNok: $relationshipWithNok, nokContactNumber: $nokContactNumber, nokAddress: $nokAddress, nokSourceOfIncome: $nokSourceOfIncome)';
  }

  @override
  bool operator ==(covariant Staff other) {
    if (identical(this, other)) return true;

    return other.profilePicture == profilePicture &&
        other.userId == userId &&
        other.username == username &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.otherNames == otherNames &&
        other.role == role &&
        other.dateOfBirth == dateOfBirth &&
        other.idNumber == idNumber &&
        other.gender == gender &&
        other.title == title &&
        other.contactNumber == contactNumber &&
        other.emailAddress == emailAddress &&
        other.creationDate == creationDate &&
        other.accountStatus == accountStatus &&
        other.homeDistrict == homeDistrict &&
        other.homeTA == homeTA &&
        other.homeVillage == homeVillage &&
        other.homeAddress == homeAddress &&
        other.district == district &&
        other.contactVillage == contactVillage &&
        other.contactTA == contactTA &&
        other.contactDistrict == contactDistrict &&
        other.contactAddress == contactAddress &&
        other.nationality == nationality &&
        other.nokName == nokName &&
        other.relationshipWithNok == relationshipWithNok &&
        other.nokContactNumber == nokContactNumber &&
        other.nokAddress == nokAddress &&
        other.nokSourceOfIncome == nokSourceOfIncome;
  }

  @override
  int get hashCode {
    return profilePicture.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        otherNames.hashCode ^
        role.hashCode ^
        dateOfBirth.hashCode ^
        idNumber.hashCode ^
        gender.hashCode ^
        title.hashCode ^
        contactNumber.hashCode ^
        emailAddress.hashCode ^
        creationDate.hashCode ^
        accountStatus.hashCode ^
        homeDistrict.hashCode ^
        homeTA.hashCode ^
        homeVillage.hashCode ^
        homeAddress.hashCode ^
        district.hashCode ^
        contactVillage.hashCode ^
        contactTA.hashCode ^
        contactDistrict.hashCode ^
        contactAddress.hashCode ^
        nationality.hashCode ^
        nokName.hashCode ^
        relationshipWithNok.hashCode ^
        nokContactNumber.hashCode ^
        nokAddress.hashCode ^
        nokSourceOfIncome.hashCode;
  }
}
