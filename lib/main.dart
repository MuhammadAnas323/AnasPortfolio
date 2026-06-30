import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://fnwfotpnnaekfchhekhx.supabase.co',
    anonKey: 'sb_publishable_rtTJB7FvNSjhEo1kgn_mQg_M6JpkqP_',
  );
  
  runApp(const ProviderScope(child: AnasPortfolioApp()));
}
