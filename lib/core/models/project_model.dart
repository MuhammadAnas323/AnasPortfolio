class ProjectModel {
  final String id;
  final String title;
  final String tagline;
  final String description;
  final String problemStatement;
  final String solution;
  final List<String> techStack;
  final List<String> features;
  final List<String> tools;
  final String? githubUrl;
  final String? liveUrl;
  final String? figmaUrl;
  final String category;
  final String accentColorHex;
  final String imageUrl;
  final String imagePublicId;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.problemStatement,
    required this.solution,
    required this.techStack,
    required this.features,
    required this.tools,
    this.githubUrl,
    this.liveUrl,
    this.figmaUrl,
    required this.category,
    required this.accentColorHex,
    required this.imageUrl,
    required this.imagePublicId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'tagline': tagline,
      'description': description,
      'problemStatement': problemStatement,
      'solution': solution,
      'techStack': techStack,
      'features': features,
      'tools': tools,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'figmaUrl': figmaUrl,
      'category': category,
      'accentColorHex': accentColorHex,
      'imageUrl': imageUrl,
      'imagePublicId': imagePublicId,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    String resolveImageUrl(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Map) return (value['url'] ?? '').toString();
      return value.toString();
    }

    String resolvePublicId(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Map) return (value['path'] ?? '').toString();
      return value.toString();
    }

    String? resolveNullableString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    }

    return ProjectModel(
      id: docId ?? map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      tagline: map['tagline']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      problemStatement: map['problemStatement']?.toString() ?? '',
      solution: map['solution']?.toString() ?? '',
      techStack: List<String>.from(map['techStack'] ?? []),
      features: List<String>.from(map['features'] ?? []),
      tools: List<String>.from(map['tools'] ?? []),
      githubUrl: resolveNullableString(map['githubUrl']),
      liveUrl: resolveNullableString(map['liveUrl']),
      figmaUrl: resolveNullableString(map['figmaUrl']),
      category: map['category']?.toString() ?? 'General',
      accentColorHex: map['accentColorHex']?.toString() ?? '#22D3EE',
      imageUrl: resolveImageUrl(map['imageUrl']),
      imagePublicId: resolvePublicId(map['imagePublicId'] ?? map['imagePath'] ?? ''),
    );
  }
}
