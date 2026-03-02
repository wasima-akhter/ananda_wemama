class CitiesDataModel {
  CitiesDataModel({this.state});

  final State? state;

  factory CitiesDataModel.fromJson(Map<String, dynamic> json) {
    return CitiesDataModel(state: json["state"] == null ? null : State.fromJson(json["state"]));
  }
}

class State {
  State({this.name, this.id, this.cities});

  final String? name;
  final int? id;
  final List<City>? cities;

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      name: json["name"],
      id: json["id"],
      cities: json["cities"] == null
          ? []
          : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
    );
  }
}

class City {
  City({this.name, this.id});

  final String? name;
  final int? id;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(name: json["name"], id: json["id"]);
  }
}
