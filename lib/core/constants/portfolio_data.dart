import '../models/project_model.dart';
import '../models/skill_model.dart';

class PortfolioData {
  static const List<ProjectModel> projects = [];

  static const List<SkillModel> skills = [
    SkillModel(id: '', name: 'Flutter', category: 'Core', emoji: '💙', proficiency: 0.95),
    SkillModel(id: '', name: 'Dart', category: 'Core', emoji: '🎯', proficiency: 0.95),
    SkillModel(id: '', name: 'Firebase', category: 'Backend', emoji: '🔥', proficiency: 0.88),
    SkillModel(id: '', name: 'Riverpod', category: 'State', emoji: '⚡', proficiency: 0.90),
    SkillModel(id: '', name: 'Bloc / Cubit', category: 'State', emoji: '🧩', proficiency: 0.85),
    SkillModel(id: '', name: 'Go Router', category: 'Navigation', emoji: '🗺️', proficiency: 0.90),
    SkillModel(id: '', name: 'REST APIs', category: 'Integration', emoji: '🔗', proficiency: 0.85),
    SkillModel(id: '', name: 'Git & GitHub', category: 'DevOps', emoji: '🐙', proficiency: 0.88),
    SkillModel(id: '', name: 'Flutter Web', category: 'Platform', emoji: '🌐', proficiency: 0.82),
    SkillModel(id: '', name: 'Figma', category: 'Design', emoji: '🎨', proficiency: 0.75),
    SkillModel(id: '', name: 'SQLite / Hive', category: 'Database', emoji: '🗄️', proficiency: 0.82),
    SkillModel(id: '', name: 'Stripe / Payments', category: 'Integration', emoji: '💳', proficiency: 0.78),
  ];

  static const Map<String, String> personalInfo = {
    'name': 'Muhammad Anas',
    'fullName': 'Muhammad Anas',
    'title': 'Flutter & Dart Developer',
    'email': 'anasktk2125@gmail.com',
    'whatsapp': '923241788391',
    'github': 'https://github.com/anas',
    'linkedin': 'https://linkedin.com/in/anas',
    'location': 'Pakistan 🇵🇰',
    'bio':
        'I\'m a passionate Flutter developer with a love for crafting beautiful, high-performance mobile and web applications. With expertise in the full Flutter ecosystem — from Riverpod state management to Firebase integration — I specialize in building products that users love and businesses depend on. My approach combines clean architecture, thoughtful UX, and performant code to deliver solutions that stand out.',
    'yearsOfExperience': '3+',
    'projectsCompleted': '20+',
    'happyClients': '15+',
  };
}
