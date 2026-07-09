import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../models/skill_model.dart';
class PortfolioData {
  static const List<ProjectModel> projects = [
    ProjectModel(
      id: 'restaurant-management',
      title: 'LuxeDine POS — Restaurant Management System',
      tagline: 'A full-featured point-of-sale and business management platform built for fine-dining and full-service restaurants.',
      description:
          'LuxeDine POS is an end-to-end restaurant operations platform that unifies order management, table tracking, inventory, staff, finances, and analytics into a single admin terminal. Designed for restaurant managers and staff, it replaces disconnected spreadsheets and paper logs with a real-time, data-driven system covering everything from taking an order to closing the books at the end of the day.\n\nMy Role:\nDesigned and developed the complete application UI/UX in Figma, then built the full front-end in Flutter using clean, modular architecture. Implemented real-time data flows and backend integration through Firebase, structured state management for complex multi-screen workflows (orders, tables, inventory), and built a fully responsive admin dashboard optimized for daily restaurant operations.',
      problemStatement:
          'Traditional restaurants rely on disconnected spreadsheets, paper logs, and manual tracking, leading to slow order placement, inaccurate billing, high inventory waste, and a lack of real-time operational visibility.',
      solution:
          'Designed and built a unified, real-time POS dashboard utilizing the Flutter framework and Firebase to centralize order workflow, table tracking, stock management, staff shifts, cash logs, and daily sales analytics.',
      techStack: [
        'Flutter',
        'Dart',
        'Firebase',
        'Riverpod',
        'Clean Architecture',
        'Figma',
        'VS Code',
        'Firebase Console'
      ],
      features: [
        '📊 Dashboard: Live overview of daily, weekly, monthly, and yearly performance — financial summary, weekly sales trends, pending vs. completed orders, and a real-time sales analytics chart broken down by dine-in and parcel orders.',
        '🧾 Order Management: Create and track orders across Walk-in, Table, and Parcel types. Orders flow through clear status stages (Pending → Preparing → Ready for Pickup → Completed), with quick actions to edit, print, or mark orders complete. A streamlined "New Order" flow lets staff select tables, add Udaar (credit) or Parcel orders, and choose from menu items or active deals in seconds.',
        '🍽️ Table Management: Real-time floor visualization showing every table\'s live status — Free, Booked, or Occupied — with guest capacity, duration, and assigned server at a glance. Includes an editable floor plan and quick "Assign Customer" actions for fast table turnover.',
        '📦 Inventory Management: Tracks stock levels, per-item value, and material health across categories (Menu, Deals, Dispose). Automatically flags low-stock and out-of-stock items, calculates profit per product, and surfaces smart optimization tips (e.g., flagging high waste in specific categories) alongside category-wise stock distribution charts.',
        '👥 Staff Management: Centralized staff directory with shift filters (Morning/Evening/Night), duty status (On Duty/Off Duty/On Leave), and full profile details including CNIC, phone number, shift schedule, and tenure — built for fast lookup during busy service hours.',
        '💵 Expense Tracking: Logs and categorizes daily expenses (utilities, inventory purchases, maintenance) with status tracking (Paid/Unpaid/Partially Paid), weekly/monthly budget comparisons, and exportable PDF reports for accounting.',
        '🏦 Cash Management: Full cash-flow visibility across Cash, Udaar (credit), and Accounts tabs — tracking total cash in/out, daily final balance, and a categorized transaction log (Sales, Cash Drops, Bills, Salaries, Vendors) with CSV/PDF export for reconciliation.',
        '📈 Reports & Analytics: Deep business intelligence with item-wise performance breakdowns (quantity sold, revenue, COGS, profit margin %), hourly revenue distribution, and sales-by-category summaries — plus drill-down views for detailed profit analysis and sales breakdowns by custom date range.',
        '⚙️ Settings: Restaurant profile configuration (business category, location), user account management, and system preferences including dark mode, language, and currency — with dedicated security and multi-terminal sync controls.',
      ],
      tools: ['Figma', 'VS Code', 'Firebase Console'],
      figmaUrl:
          'https://www.figma.com/board/5EAwjAw2M2wuPAMZc3S5hF/Untitled?node-id=0-1&t=G885anTJiHslrywo-1',
      category: 'Enterprise',
      accentColorHex: '#FF6B35',
      imageUrl: 'assets/images/resturent_management/Dashboared.png',
      imagePublicId: 'local',
    ),
  ];

  static const List<SkillModel> skills = [
    // Languages
    SkillModel(id: 'dart', name: 'Dart', category: 'Languages', emoji: '🎯', proficiency: 0.95, barColor: Color(0xFF00B4FF)),

    // Framework
    SkillModel(id: 'flutter', name: 'Flutter', category: 'Framework', emoji: '💙', proficiency: 0.95, barColor: Color(0xFF54C5F8)),

    // State Management
    SkillModel(id: 'riverpod', name: 'Riverpod', category: 'State Management', emoji: '⚡', proficiency: 0.92, barColor: Color(0xFF66BB6A)),
    SkillModel(id: 'provider', name: 'Provider', category: 'State Management', emoji: '🔌', proficiency: 0.88, barColor: Color(0xFF4CAF50)),
    SkillModel(id: 'getx', name: 'GetX', category: 'State Management', emoji: '🚀', proficiency: 0.85, barColor: Color(0xFF81C784)),

    // Backend
    SkillModel(id: 'firebase', name: 'Firebase', category: 'Backend', emoji: '🔥', proficiency: 0.90, barColor: Color(0xFFFF6F00)),
    SkillModel(id: 'supabase', name: 'Supabase', category: 'Backend', emoji: '⚡', proficiency: 0.82, barColor: Color(0xFF3ECF8E)),

    // Architecture
    SkillModel(id: 'clean_arch', name: 'Clean Architecture', category: 'Architecture', emoji: '🏛️', proficiency: 0.88, barColor: Color(0xFFFF9800)),
    SkillModel(id: 'mvvm', name: 'MVVM', category: 'Architecture', emoji: '🧱', proficiency: 0.90, barColor: Color(0xFFFFB74D)),
    SkillModel(id: 'modular', name: 'Modular Design', category: 'Architecture', emoji: '🔧', proficiency: 0.85, barColor: Color(0xFFE65100)),

    // Integrations
    SkillModel(id: 'rest_api', name: 'REST APIs', category: 'Integrations', emoji: '🔗', proficiency: 0.93, barColor: Color(0xFFE53935)),
    SkillModel(id: 'google_maps', name: 'Google Maps', category: 'Integrations', emoji: '🗺️', proficiency: 0.85, barColor: Color(0xFF4285F4)),
    SkillModel(id: 'firebase_auth', name: 'Firebase Authentication', category: 'Integrations', emoji: '🔑', proficiency: 0.90, barColor: Color(0xFFFFCA28)),
    SkillModel(id: 'push_notifications', name: 'Push Notifications', category: 'Integrations', emoji: '🔔', proficiency: 0.88, barColor: Color(0xFF00E676)),

    // Development Tools
    SkillModel(id: 'git', name: 'Git & GitHub', category: 'Development Tools', emoji: '🐙', proficiency: 0.90, barColor: Color(0xFFF44336)),
    SkillModel(id: 'vscode', name: 'VS Code', category: 'Development Tools', emoji: '💻', proficiency: 0.95, barColor: Color(0xFF2196F3)),
    SkillModel(id: 'android_studio', name: 'Android Studio', category: 'Development Tools', emoji: '🤖', proficiency: 0.88, barColor: Color(0xFF4CAF50)),

    // AI Development Tools
    SkillModel(id: 'cursor', name: 'Cursor', category: 'AI Development Tools', emoji: '🖱️', proficiency: 0.90, barColor: Color(0xFF00E5FF)),
    SkillModel(id: 'kiro', name: 'Kiro', category: 'AI Development Tools', emoji: '🤖', proficiency: 0.80, barColor: Color(0xFFD500F9)),
    SkillModel(id: 'trae', name: 'Trae', category: 'AI Development Tools', emoji: '⚡', proficiency: 0.82, barColor: Color(0xFF00E676)),
    SkillModel(id: 'antigravity', name: 'Antigravity AI', category: 'AI Development Tools', emoji: '🛸', proficiency: 0.95, barColor: Color(0xFFFF007F)),
  ];
  static const Map<String, String> personalInfo = {
    'name': 'Muhammad Anas',
    'fullName': 'Muhammad Anas',
    'title': 'Flutter Developer',
    'email': 'anasktk2125@gmail.com',
    'whatsapp': '923241788391',
    'github': 'https://github.com/anas',
    'linkedin': 'https://linkedin.com/in/anas',
    'location': 'Pakistan 🇵🇰',
    'bio':
        'I am a professional Flutter Developer specializing in cross-platform mobile app development using Dart and the Flutter framework. Experienced in designing robust state management (Riverpod/Provider) architecture, seamless REST API integration, and Firebase backends. I focus on premium UI/UX, clean architecture, performance optimization, and writing clean, scalable code to deliver high-impact production apps.',
    'yearsOfExperience': '1+',
    'projectsCompleted': '10+',
    'happyClients': '5+',
  };
}
