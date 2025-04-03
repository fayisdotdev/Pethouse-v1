class Pet {
  final int id;
  final String userName;
  final String name;
  final String petImage;
  final bool isFriendly;

  Pet({
    required this.id,
    required this.userName,
    required this.name,
    required this.petImage,
    required this.isFriendly,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      name: json['petName'] ?? '',
      petImage: json['petImage'] ?? '',
      isFriendly: json['isFriendly'] ?? false,
    );
  }
}
