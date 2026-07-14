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
    // ── GPS Attendance & Payroll System ─────────────────────────────────────
    ProjectModel(
      id: 'geo-attend',
      title: 'GPS Attendance & Payroll System',
      tagline: 'A location-verified attendance and payroll management platform that eliminates fake clock-ins through real-time geofencing.',
      description:
          'GeoAttend is a mobile-first attendance system built for businesses that need to guarantee employees are physically present at their assigned work location before attendance is recorded. Using live GPS verification and geofencing, the app blocks clock-in/clock-out attempts from outside an employer-defined radius, then automatically compiles the data into payroll-ready reports — removing manual timesheets and eliminating attendance fraud.\n\nMy Role:\nLed the design and development of the mobile application architecture, implementing GPS-based geofencing logic, real-time location verification, and REST API integration with a cloud backend. Built the employee-facing clock-in flow (map view, live location status, one-tap clock in/out) and contributed to the employer admin dashboard for attendance monitoring and report generation.',
      problemStatement:
          'Businesses lose significant time and money to manual timesheets, buddy punching, and fraudulent remote clock-ins that cannot verify whether an employee is actually on-site.',
      solution:
          'Built a Flutter app with live GPS geofencing that physically verifies employee location at the moment of clock-in. Server-side timestamps (not device clocks) prevent manipulation, and one-click payroll exports remove all manual processing.',
      techStack: [
        'Flutter',
        'Dart',
        'Google Maps API',
        'Firebase',
        'REST APIs',
        'Push Notifications',
        'Clean Architecture',
      ],
      features: [
        '📍 Geofenced Clock In / Clock Out: Employers define one or multiple work locations directly on a map with a configurable radius (e.g. 100m). The app continuously checks device GPS against this boundary and only enables the Clock In/Out button when the employee is physically within range — with server-side timestamps (not device clocks) to prevent time manipulation.',
        '🕒 Attendance Logging: Every clock-in/out event captures employee ID, date, time, GPS coordinates, location name, and computed total working hours — automatically classifying each day as Present, Late, Absent, or Half-day.',
        '🖥️ Employer Admin Dashboard: A centralized web dashboard giving employers full visibility: employee roster management, real-time clock-in status across the team, daily attendance overview, and instant flags for late arrivals, early departures, and absentees.',
        '📊 Payroll-Ready Reports: One-click export of attendance data in Excel, PDF, or CSV — including hours worked, overtime, location, and status per employee per day — formatted for direct use in salary and payroll processing.',
        '🏖️ Leave & Exception Management: Employees can submit leave requests in-app; employers approve or reject them. Holidays, weekends, and missed clock-ins with manual override are all handled within the same system, keeping attendance records complete and accurate.',
        '🔒 Anti-Fraud & Security: Mock/fake GPS detection blocks spoofed locations, device binding limits one account per phone, and OTP/password login with role-based access (Admin vs. Employee) keeps the system secure end-to-end.',
      ],
      tools: ['VS Code', 'Google Maps API', 'Firebase Console'],
      figmaUrl: 'https://www.figma.com/board/UK3rbWbCp5vJFwZmEpbD3Y/Untitled?node-id=1-818&t=DUXuCNmL2Bm6SFQa-1',
      category: 'Mobile App',
      accentColorHex: '#22C55E',
      imageUrl: 'assets/images/gps/Screenshot 2026-07-09 153458.png',
      imagePublicId: 'local',
    ),

    // ── TO DO — Task & Productivity Management App ───────────────────────────
    ProjectModel(
      id: 'todo-app',
      title: 'TO DO — Task & Productivity App',
      tagline: 'A clean, intuitive task management app that helps individuals and teams plan, schedule, and track their daily productivity.',
      description:
          'TO DO is a mobile productivity app designed to help users organize personal and team tasks in one place. From onboarding through daily use, the app focuses on simplicity — letting users create tasks, set schedules, collaborate with teams, and track completion status without unnecessary complexity.\n\nMy Role:\nDesigned the complete UI/UX in Figma with a consistent blue gradient theme and custom 3D iconography, then developed the full application in Flutter — implementing the onboarding flow, Firebase-based authentication (including Google/Apple sign-in), task CRUD operations, calendar-based scheduling, and state management across all screens.',
      problemStatement:
          'Individuals and teams struggle with scattered to-do lists, missed deadlines, and no single place to manage both personal and collaborative tasks with a scheduling view.',
      solution:
          'Built a focused Flutter productivity app with Firebase auth, calendar-based task scheduling, collaborative group tasks, and a clean bottom-sheet task creation flow that keeps the experience fast and frictionless.',
      techStack: [
        'Flutter',
        'Dart',
        'Firebase',
        'Firebase Authentication',
        'Riverpod',
        'Google Sign-In',
        'Clean Architecture',
      ],
      features: [
        '👋 Onboarding Experience: A polished 3-step onboarding flow introduces core value propositions — task planning, weekly scheduling, and team collaboration — followed by a security assurance screen, giving new users a clear sense of what the app offers before signup.',
        '🔐 Authentication: Complete auth flow including Sign In, Sign Up, and account verification via code — with Apple and Google sign-in options for faster onboarding, alongside traditional email/password login.',
        '🏠 Home Dashboard: A personalized home screen greeting the user by name, showing upcoming Group Tasks (with participant avatars and meeting times), plus separate sections for Incomplete Tasks and Completed Tasks — giving an at-a-glance view of the day\'s priorities.',
        '✅ Task List & Management: A dedicated task list screen with search-by-title and sort functionality. Tasks can be created via a clean bottom-sheet modal capturing title, description, date, and time — keeping task creation fast and frictionless.',
        '📝 Task Details: Each task opens into a detailed view showing title, date, time, and full description, with quick actions to mark as Done, Delete, or Pin — supporting flexible task prioritization.',
        '📅 Calendar & Time Management: A dedicated "Manage Your Time" calendar view lets users navigate month-by-month, select any date, and assign tasks directly to that day — turning the app into a lightweight scheduling tool alongside its task list.',
        '⚙️ Settings: Centralized settings screen covering Profile, Conversations, Projects, and Terms & Policies, with a clear logout action — keeping account management simple and accessible.',
      ],
      tools: ['Figma', 'VS Code', 'Firebase Console'],
      figmaUrl: 'https://www.figma.com/design/Lulxy63OQ6lU17SWUoNMP7/Todo-App--Community-?node-id=0-1&p=f&t=dg5EU1awbAXDrLqA-0',
      category: 'Mobile App',
      accentColorHex: '#22D3EE',
      imageUrl: 'assets/images/TODO/Screenshot 2026-07-09 160918.png',
      imagePublicId: 'local',
    ),

    // ── FitLife Ecosystem — Digital Health & Fitness Platform ──────────────
    ProjectModel(
      id: 'fitlife-health',
      title: 'FitLife Ecosystem — Digital Health & Fitness Platform',
      tagline: 'A modern, high-fidelity digital health ecosystem comprising a mobile app for end-users and a centralized web-based administration dashboard.',
      description:
          'FitLife is a modern, high-fidelity digital health and fitness ecosystem comprising two major components: a mobile application for end-users and a centralized web-based administration dashboard. This platform empowers users to transform their bodies, improve their lifestyles, and adopt sustainable nutrition, while equipping administrators with real-time data insights and robust user management capabilities.\n\nMy Role:\nDesigned the complete UI/UX in Figma and developed the full Flutter mobile application with Firebase backend integration, including social authentication, health profile tracking with BMI calculation, and real-time synchronization with the admin dashboard for content management and user analytics.',
      problemStatement:
          'Health and fitness platforms often use a one-size-fits-all approach to diet and nutrition, failing to account for individual body composition, daily routines, and health goals — while administrators lack real-time visibility into user engagement and platform growth.',
      solution:
          'Built a dual-platform ecosystem with a Flutter mobile app for personalized health tracking and a responsive admin dashboard for real-time analytics. Users receive custom diet plans based on their physiological profile, while administrators gain data-driven insights through dynamic charts and complete user moderation capabilities.',
      techStack: [
        'Flutter',
        'Dart',
        'Firebase',
        'Firebase Authentication',
        'Riverpod',
        'Google Sign-In',
        'Apple Sign-In',
        'Facebook Login',
        'Clean Architecture',
        'Figma',
      ],
      features: [
        '📊 Interactive Onboarding: A guided presentation upon first launch highlighting core benefits — Transformation, Tailored Plans, and Motivation — ensuring users understand the platform\'s value before registration.',
        '🔐 Multi-Platform Authentication: Standard email/password registration alongside single-tap social SSO via Google, Facebook, and Apple — plus a self-service password recovery flow for lost credentials.',
        '🧬 Physiological Health Profile: Users build a complete health profile with body attributes for accurate BMI (Body Mass Index) calculation, enabling truly personalized nutrition and diet plan recommendations.',
        '📋 Customized Diet Plans: Moving away from generic templates, every user receives a custom diet plan aligned with their unique health goals, daily routine, and body composition — focused on sustainable nutrition and hormone balance.',
        '📈 Real-Time Admin Analytics: A centralized web dashboard featuring dynamic line charts with daily, weekly, monthly, and yearly statistical breakdowns of user growth (New Users vs. Total Users) for data-driven business decisions.',
        '👥 User Management & Moderation: Complete user directory grid with search and filtering tools. Administrators can instantly toggle active, inactive, or blocked states and delete accounts that violate guidelines — ensuring a safe community environment.',
        '📝 Content Management System: Admins can upload new nutritional assets and diet plans through the content module, which are instantly synchronized and pushed live to the mobile application users in real time.',
        '🎫 Customer Support Ticketing: A dedicated support interface that allows administrators to efficiently manage, track, and resolve user inquiries and support requests through an organized ticketing system.',
      ],
      tools: ['Figma', 'VS Code', 'Firebase Console'],
      figmaUrl: 'https://www.figma.com/design/xDRaaWmSn3P4LEQEyVy7XK/Fitlife?node-id=0-1&t=T3RfkPvLyKL2ScQG-1',
      category: 'Health & Fitness',
      accentColorHex: '#10B981',
      imageUrl: 'assets/images/Fitlife/Screenshot 2026-07-10 140129.png',
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
        'Every great application starts with an idea. My job is to transform that idea into a product people love to use.\n\n'
        "Hi, I'm Muhammad Anas, a Flutter & Dart Developer passionate about building scalable, high-performance mobile applications that solve real business problems.\n\n"
        'My journey into software development was not simply about learning a programming language — it was about understanding how technology can improve businesses and simplify people\u2019s lives. Every project I build teaches me something new, and every challenge pushes me to become a better engineer.\n\n'
        'I believe that writing code is only a small part of software development. Understanding user behavior, business goals, application architecture, and long-term scalability is what truly separates a developer from a software engineer.\n\n'
        'Over time, I have developed expertise in building cross-platform applications using Flutter, integrating REST APIs, Firebase, and implementing clean architectures with Riverpod and Provider. I enjoy creating applications that are not only visually appealing but also fast, maintainable, secure, and production-ready.\n\n'
        'What excites me the most is solving complex problems. Whether it is optimizing application performance, designing scalable architectures, integrating cloud services, or creating intuitive user experiences, I enjoy finding efficient solutions that make a real difference.\n\n'
        'I approach every project with one simple philosophy:\n\n'
        'Build software that creates value — not just software that works.\n\n'
        'I continuously explore new technologies, improve my development workflow, and stay updated with modern software engineering practices because I believe learning never stops in this industry.\n\n'
        'When I work with clients or development teams, my focus is on clear communication, clean code, timely delivery, and long-term maintainability. My goal is not just to complete projects — it is to build products that businesses can confidently grow with.\n\n'
        "If you're looking for someone who takes ownership, thinks beyond the code, and genuinely cares about delivering quality software, I would be glad to be part of your journey.\n\n"
        "Let's build something exceptional together.",
    'yearsOfExperience': '1+',
    'projectsCompleted': '10+',
    'happyClients': '5+',
  };
}
