class LearningTopic {
  final String id;
  final String name;
  final String category;
  final String description;
  final String lastViewed;
  final String modelType;

  LearningTopic({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.lastViewed,
    required this.modelType,
  });
}

class FakeData {
  static List<LearningTopic> featuredTopics = [
    LearningTopic(
      id: '1',
      name: 'Solar System',
      category: 'Astronomy',
      description: 'Explore planets and their orbits around the sun',
      lastViewed: '2 hours ago',
      modelType: '3D Animation',
    ),
    LearningTopic(
      id: '2',
      name: 'Human Heart',
      category: 'Biology',
      description: 'Interactive 3D model showing heart chambers and blood flow',
      lastViewed: '1 day ago',
      modelType: '3D Model',
    ),
    LearningTopic(
      id: '3',
      name: 'Photosynthesis',
      category: 'Biology',
      description: 'Animated process of plant energy production',
      lastViewed: '3 days ago',
      modelType: '3D Animation',
    ),
  ];

  static List<LearningTopic> recentTopics = [
    LearningTopic(
      id: '4',
      name: 'Water Cycle',
      category: 'Geography',
      description: 'Evaporation, condensation, and precipitation process',
      lastViewed: 'Just now',
      modelType: '3D Animation',
    ),
    LearningTopic(
      id: '5',
      name: 'Atomic Structure',
      category: 'Chemistry',
      description: 'Protons, neutrons, and electrons in atom models',
      lastViewed: '5 minutes ago',
      modelType: '3D Model',
    ),
    LearningTopic(
      id: '6',
      name: 'Volcano Eruption',
      category: 'Geography',
      description: 'Cross-section view of volcanic activity',
      lastViewed: '1 hour ago',
      modelType: '3D Animation',
    ),
  ];

  static List<String> quickConcepts = [
    'Solar System',
    'Human Heart',
    'Photosynthesis',
    'Water Cycle',
    'Atomic Structure',
    'Volcano',
    'Plant Cell',
    'DNA Structure',
    'Magnetism',
    'Electric Circuit',
  ];
}