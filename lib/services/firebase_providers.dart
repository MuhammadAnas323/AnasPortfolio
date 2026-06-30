import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/project_model.dart';
import '../core/models/skill_model.dart';

/// StreamProvider that tracks the authentication state of the user.
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// StreamProvider that monitors the 'projects' collection in Firestore in real-time.
final projectsStreamProvider = StreamProvider<List<ProjectModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('projects')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  });
});

/// StateProvider to manage the loading/uploading state of files.
final isUploadingProvider = StateProvider<bool>((ref) => false);

/// StreamProvider that monitors the 'skills' collection in Firestore in real-time.
final skillsStreamProvider = StreamProvider<List<SkillModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('skills')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
        .toList();
  });
});

/// StreamProvider that monitors the 'settings/personal_info' document
final personalInfoStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return FirebaseFirestore.instance
      .collection('settings')
      .doc('personal_info')
      .snapshots()
      .map((snapshot) => snapshot.data() ?? {});
});
