import 'package:emim/data/districts.dart';

class District {
  String name;
  List<String> traditionalAuthorities;

  District(this.name, this.traditionalAuthorities);
}

String getSelectedDistrict(Map<String, dynamic> user) {
  final district = user['nokPhysicalAddress'] == 'N/A'
      ? districts[0].name
      : districts[user['nokPhysicalAddress']].name;

  return district;
}

List<String> getTraditionalAuthorities(
  String selectedDistrict,
) {
  final traditionalAuthorities = districts
      .firstWhere((district) => district.name == selectedDistrict)
      .traditionalAuthorities;

  return traditionalAuthorities;
}

String? getSelectedTa(
  Map<String, dynamic> user,
  String key,
  selectedDistrict,
) {
  final traditionalAuthorities = getTraditionalAuthorities(selectedDistrict);
  final selectedTa = !traditionalAuthorities.contains(user[key])
      ? traditionalAuthorities[0]
      : traditionalAuthorities[user[key]];

  return selectedTa;
}
