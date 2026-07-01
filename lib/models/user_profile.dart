class UserProfile {
  final String id;
  final String name;
  final double weight;
  final double height;
  final List<double> progressData;

  UserProfile({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.progressData,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'height': height,
      'progressData': progressData,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      weight: (map['weight'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      progressData: List<double>.from(map['progressData'] ?? []),
    );
  }
}
