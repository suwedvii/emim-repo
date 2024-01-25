List<String> relationshipsList = [
  "Select Relationship",
  "Spouse/Civil Partner",
  "Child",
  "Parent",
  "Sibling",
  "Grandchild",
  "Grandparent",
  "Aunt/Uncle",
  "Niece/Nephew",
  "Cousin",
  "In-Law",
  "Godparent",
  "Friend/Coleague"
];

String getSelectedRelationship(
  Map<String, dynamic> user,
  selectedRelatiionship,
) {
  final relationship = selectedRelatiionship == 'N/A'
      ? relationshipsList[0]
      : relationshipsList
          .firstWhere((relationship) => relationship == selectedRelatiionship);

  return relationship;
}

List<String> sourceOfIncome = [
  'Select Source',
  'Salary',
  'Business',
  'Inheritance'
];

String getSourceOfIncome(Map<String, dynamic> user) {
  final selectedSourse = user['nokSourceOfIncome'] == 'N/A'
      ? sourceOfIncome[0]
      : sourceOfIncome
          .firstWhere((source) => source == user['nokSourceOfIncome']);
  return selectedSourse;
}
