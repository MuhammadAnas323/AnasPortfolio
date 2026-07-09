import 'package:flutter/material.dart';

class SkillModel {
  final String id;
  final String name;
  final String category;
  final String emoji;
  final double proficiency; // 0.0 to 1.0
  final Color barColor;

  const SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.proficiency,
    this.barColor = const Color(0xFF00D4FF),
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'emoji': emoji,
      'proficiency': proficiency,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SkillModel(
      id: documentId,
      name: map['name'] ?? '',
      category: map['category'] ?? 'Core',
      emoji: map['emoji'] ?? '🚀',
      proficiency: (map['proficiency'] ?? 0.0).toDouble(),
    );
  }
}
