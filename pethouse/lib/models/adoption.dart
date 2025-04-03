class Adoption {
  final String name;
  final int age;
  final String gender;
  final int numberOfPets;
  final List<Map<String, dynamic>> selectedPets;
  final DateTime applicationDate;

  Adoption({
    required this.name,
    required this.age,
    required this.gender,
    required this.numberOfPets,
    required this.selectedPets,
    required this.applicationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Age': age,
      'Gender': gender,
      'NumberOfPets': numberOfPets,
      'selectedpets': selectedPets,
      'applicationdate': applicationDate.toIso8601String(),
    };
  }
}
