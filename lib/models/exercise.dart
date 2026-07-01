class Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String target;
  final String muscles;
  final String equipment;
  final String image;
  final List<String> instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.muscles,
    required this.equipment,
    required this.image,
    required this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      target: json['target'] ?? '',
      muscles: json['muscles'] ?? 'Various',
      equipment: json['equipment'] ?? 'Bodyweight',
      image: json['image'] ?? json['gifUrl'] ?? 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&q=80&w=800',
      instructions: json['instructions'] is List 
          ? List<String>.from(json['instructions'])
          : [json['instructions'] ?? 'No instructions available.'],
    );
  }
}

const Map<String, String> categoryMap = {
  'Abs': 'waist',
  'Arms': 'upper arms',
  'Back': 'back',
  'Chest': 'chest',
  'Legs': 'upper legs',
  'Shoulders': 'shoulders'
};
