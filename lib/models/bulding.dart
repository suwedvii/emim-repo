enum Campuses { blantyre, lilongwe }

class Building {
  Campuses campus;
  String name;
  List<String> rooms;

  Building(this.name, this.campus, this.rooms);
}

List<Building> dummyBuildings = [
  Building(
      'Block 1', Campuses.blantyre, ['Room 1', 'Room 2', 'Computer Lab 1']),
  Building('Chikanda', Campuses.lilongwe, ['Room 1', 'Room 2', 'Computer Lab']),
];

List<String> getBuildings() {
  List<String> buldings = [];
  for (var building in dummyBuildings) {
    buldings.add(building.name);
  }
  return buldings;
}
