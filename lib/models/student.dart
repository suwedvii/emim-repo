import 'package:emim/models/user.dart';

class Student extends User {
  String studentId = '';
  String userCampus = '';
  String userProgram = '';
  String userCohort = '';
  String registeredSemester;

  Student(
      {required this.studentId,
      required this.userCampus,
      required this.userProgram,
      required this.userCohort,
      this.registeredSemester = '',
      super.profilePicture = '',
      super.userId = '',
      super.username = '',
      super.password = '',
      super.firstName = '',
      super.lastName = '',
      super.otherNames = '',
      super.role = '',
      super.dateOfBirth = '',
      super.idNumber = '',
      super.gender = '',
      super.title = '',
      super.contactNumber = '',
      super.emailAddress = '',
      super.creationDate = '',
      super.accountStatus = '',
      super.homeDistrict = '',
      super.homeTA = '',
      super.homeVillage = '',
      super.homeAddress = '',
      super.district = '',
      super.contactVillage = '',
      super.contactTA = '',
      super.contactDistrict = '',
      super.contactAddress = '',
      super.nationality = '',
      super.nokName = '',
      super.relationshipWithNok = '',
      super.nokContactNumber = '',
      super.nokAddress = '',
      super.nokSourceOfIncome = ''});
}
