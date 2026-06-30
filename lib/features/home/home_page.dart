import 'package:flutter/material.dart';
import '../nav/nav_bar.dart';
import '../hero/hero_section.dart';
import '../projects/projects_section.dart';
import '../skills/skills_section.dart';
import '../about/about_section.dart';
import '../contact/contact_section.dart';
import '../work/work_section.dart';
import '../../core/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 64),
                HeroSection(sectionKey: _heroKey, onViewWork: () => _scrollTo(_projectsKey)),
                ProjectsSection(sectionKey: _projectsKey),
                SkillsSection(sectionKey: _skillsKey),
                WorkSection(sectionKey: _experienceKey),
                AboutSection(sectionKey: _aboutKey),
                ContactSection(sectionKey: _contactKey),
              ],
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: NavBar(
              scrollController: _scrollController,
              heroKey: _heroKey,
              projectsKey: _projectsKey,
              skillsKey: _skillsKey,
              experienceKey: _experienceKey,
              aboutKey: _aboutKey,
              contactKey: _contactKey,
            ),
          ),
        ],
      ),
    );
  }
}
