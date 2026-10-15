import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Experience {
  const Experience({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.points,
  });
  final String role;
  final String company;
  final String period;
  final String location;
  final List<String> points;
}

class Project {
  const Project({
    required this.name,
    required this.tagline,
    required this.icon,
    required this.points,
    required this.metrics,
    required this.tags,
    required this.link,
    required this.linkLabel,
    required this.linkIcon,
  });
  final String name;
  final String tagline;
  final IconData icon;
  final List<String> points;
  final List<String> metrics;
  final List<String> tags;
  final String link;
  final String linkLabel;
  final FaIconData linkIcon;
}

class SkillGroup {
  const SkillGroup(this.title, this.icon, this.items);
  final String title;
  final IconData icon;
  final List<String> items;
}

class Stat {
  const Stat(this.value, this.label, {this.suffix = '', this.decimals = 0});
  final double value;
  final String label;
  final String suffix;
  final int decimals;
}

/// All portfolio content, taken from the resume. Edit here to update the site.
abstract final class PortfolioData {
  static const String name = 'Kathiravan K';
  static const String initials = 'KK';
  static const String location = 'Chennai, India';

  /// Optional: put a photo at assets/images/profile.jpg and set this to
  /// 'assets/images/profile.jpg' to replace the initials avatar.
  static const String profileAsset = 'assets/images/profile.png';

  static const List<String> roles = [
    'Flutter Developer',
    'Cross-Platform App Engineer',
    'Clean Architecture Enthusiast',
    'Mobile UI/UX Craftsman',
  ];

  static const String heroIntro =
      'I build fast, polished cross-platform apps with Flutter & Dart. '
      '3+ years across retail & POS, ed-tech, healthcare, fitness and social '
      'media, with 5+ production apps live on Google Play and the App Store.';

  static const List<String> aboutParagraphs = [
    'I\'m a results-driven Flutter developer based in Chennai who architects '
        'clean, modular, Clean-Architecture-based apps that feel fast and look '
        'great on every screen.',
    'I\'ve delivered 5+ production apps on Google Play and the App Store, '
        'including an AI-powered POS & billing ecosystem (Fulupo), an AI '
        'video-generation social app (Selfitoons) and an internship discovery '
        'platform (Internsharks.ai).',
    'I care about measurable impact: faster checkouts, higher payment success, '
        'leaner network payloads and zero-error, requirement-driven delivery.',
  ];

  static const List<String> aboutHighlights = [
    'GetX',
    'Bloc / Cubit',
    'Firebase',
    'REST (Dio)',
    'Google ML Kit',
    'Bluetooth ESC/POS',
    'Cashfree',
    'Razorpay',
  ];

  static const List<Stat> stats = [
    Stat(3, 'Years of Flutter experience', suffix: '+'),
    Stat(5, 'Production apps live', suffix: '+'),
    Stat(50, 'Screens shipped', suffix: '+'),
    Stat(98.5, 'Payment success rate', suffix: '%', decimals: 1),
  ];

  static const List<SkillGroup> skills = [
    SkillGroup('Languages', Icons.code_rounded, [
      'Dart',
      'HTML & CSS',
      'Python (Basics)',
    ]),
    SkillGroup('Framework & State', Icons.phone_iphone_rounded, [
      'Flutter',
      'GetX',
      'Bloc / Cubit',
      'GoRouter',
      'Clean Architecture',
    ]),
    SkillGroup('Backend & Cloud', Icons.cloud_outlined, [
      'Firebase',
      'FCM',
      'Crashlytics',
      'Supabase',
      'REST APIs (Dio)',
      'SharedPreferences',
    ]),
    SkillGroup('Integrations', Icons.extension_outlined, [
      'Cashfree',
      'Razorpay',
      'Google ML Kit',
      'Bluetooth ESC/POS',
      'FFmpeg',
      'UAE PASS',
      'Deep Linking',
    ]),
    SkillGroup('Tools', Icons.build_outlined, [
      'Git',
      'GitHub',
      'Postman',
      'Xcode',
      'Figma',
      'MS Office',
    ]),
    SkillGroup('Platforms & Soft Skills', Icons.devices_rounded, [
      'Android',
      'iOS',
      //'Windows',
      'macOS',
      'Problem Solving',
      'Self-learning',
      'Innovation',
      'Adaptability',
    ]),
  ];

  static const List<Experience> experience = [
    Experience(
      role: 'Flutter Developer',
      company: 'DoubleTap Innovations and Technologies Pvt. Ltd.',
      period: 'Jan 2025 – Present',
      location: 'Chennai (On-site)',
      points: [
        'Architected & shipped 3 production Flutter apps (Internsharks.ai, Fulupo Retail & POS Ecosystem and Selfitoons) across 50+ screens using GetX, Bloc and Clean Architecture, live on Google Play Store and Apple App Store.',
        'Engineered an AI-powered POS system with Google ML Kit scanning and Bluetooth ESC/POS printing, cutting checkout time by 40% and inventory discrepancies by 30%.',
        'Integrated Cashfree and Razorpay payment gateways across products, achieving a 98.5% payment success rate and boosting in-app transactions by up to 50%.',
        'Built an AI-powered resume builder and automated MCQ assessment pipeline, lifting candidate profile completion by 45% and recruiter evaluation efficiency by 60%.',
        'Optimized performance via Dio interceptors, local caching and FFmpeg-based client-side video processing, cutting network payload by 30%, render latency by 40% and server CPU load by 75%.',
        'Integrated Firebase FCM, Crashlytics and Bluetooth hardware APIs, boosting store operational efficiency by 35% and consumer repeat orders by 20%.',
      ],
    ),
    Experience(
      role: 'Senior Software Engineer',
      company: 'Datayaan Solutions Pvt. Ltd.',
      period: 'Jul 2023 – Dec 2024',
      location: 'Chennai (On-site)',
      points: [
        'Delivered 2 high-performance Flutter apps with full App Store / Play Store release compliance, cutting development effort by 30% through scalable, reusable architecture.',
        'Resolved a critical 16KB page-size rendering issue, improving crash-free stability across production builds.',
        'Integrated UAE PASS authentication and deep-linking with analytics tracking, enabling secure onboarding and smooth re-entry for Dubai-based users.',
        'Converted Figma designs into responsive, pixel-perfect UI, improving usability and cutting design-to-code revisions.',
        'Strengthened QA through structured code reviews, performance instrumentation and production monitoring, reducing post-release defects.',
        'Mentored junior developers and led Agile stand-ups, cutting onboarding time and contributing to CI/CD pipeline improvements.',
      ],
    ),
    Experience(
      role: 'Web Development Intern',
      company: 'Brazy Academy, Tirunelveli',
      period: 'May – Jun 2023',
      location: 'Online',
      points: [
        'Learned fundamentals of web development using HTML, CSS and JavaScript.',
        'Implemented responsive UI designs and basic web functionalities.',
      ],
    ),
  ];

  static const List<Project> projects = [
    Project(
      name: 'Internsharks.ai',
      tagline:
          'Cross-platform internship discovery app for students and recruiters.',
      icon: Icons.school_rounded,
      points: [
        'Architected a dual-portal app with Flutter & GetX (Clean Architecture) across 50+ screens, reducing code duplication by 35% via modular dependency injection.',
        'Integrated the Cashfree SDK with a credit-based monetization model, boosting in-app micro-transactions by 50%.',
        'Designed an AI-powered conversational resume builder with real-time PDF preview and multi-template export, increasing profile completion by 45%.',
        'Built an automated MCQ skill-assessment & certificate pipeline plus FCM-driven engagement, lifting recruiter evaluation efficiency by 60% and retention by 25%.',
      ],
      metrics: ['50+ screens', '+50% transactions', '+45% profiles'],
      tags: ['Flutter', 'GetX', 'Cashfree', 'FCM', 'PDF'],
      link:
          'https://play.google.com/store/apps/details?id=com.doubletap.internsharks.ai&hl=en_IN',
      linkLabel: 'Google Play',
      linkIcon: FontAwesomeIcons.googlePlay,
    ),
    Project(
      name: 'Fulupo Retail & POS',
      tagline:
          'Omnichannel POS, billing and delivery platform for store managers and consumers.',
      icon: Icons.point_of_sale_rounded,
      points: [
        'Engineered an AI-powered POS & billing system with Google ML Kit scanning and Bluetooth ESC/POS printing, cutting checkout time by 40%.',
        'Architected real-time inventory, order and returns workflows, reducing inventory discrepancies and wastage by 30%.',
        'Integrated Cashfree payments and slot-based delivery scheduling, achieving 98.5% payment success and 35% faster order completion.',
        'Optimized GetX state management and Dio caching, improving launch speed by 25% and cutting network payload by 30%.',
      ],
      metrics: ['-40% checkout time', '98.5% payment success', '-30% wastage'],
      tags: ['Flutter', 'ML Kit', 'ESC/POS', 'Dio', 'GetX'],
      link:
          'https://play.google.com/store/apps/details?id=com.doubletap.fulupo',
      linkLabel: 'Google Play',
      linkIcon: FontAwesomeIcons.googlePlay,
    ),
    Project(
      name: 'Selfitoons',
      tagline: 'AI-powered video generation and social media app.',
      icon: Icons.movie_creation_rounded,
      points: [
        'Built an AI-powered video generation & social media app, live on Google Play Store and Apple App Store.',
        'Implemented client-side video watermarking via FFmpeg, shifting compute to the device and cutting server-side CPU load by 75%.',
        'Engineered a custom Video Controller Manager (pool of 5 active controllers), eliminating memory leaks and boosting feed scroll FPS.',
        'Architected a social feed (follows, likes, comments) using Bloc & GoRouter; integrated Razorpay and Cashfree for premium subscriptions.',
      ],
      metrics: ['-75% server CPU', 'Play Store + App Store'],
      tags: ['Flutter', 'Bloc', 'GoRouter', 'FFmpeg', 'Razorpay'],
      link:
          'https://play.google.com/store/apps/details?id=com.doubletap.ai.selfitoons',
      linkLabel: 'Google Play',
      linkIcon: FontAwesomeIcons.googlePlay,
    ),
    Project(
      name: 'Athics',
      tagline:
          'Trainer / member fitness app with booking, assessments, diet & workout plans and vitals tracking.',
      icon: Icons.fitness_center_rounded,
      points: [
        'Built a modular Flutter & GetX app scaled to 1000+ active users while maintaining 99% crash-free sessions.',
        'Developed member features (bookings, branch switching, diet/workout auto-tracking), lifting member engagement by 30%.',
        'Built trainer tools (attendance, workout assignment, assessments), improving trainer productivity by 35%.',
        'Partnered with QA and backend teams on API integration, cutting post-release defects by 20%.',
      ],
      metrics: ['1000+ users', '99% crash-free', '+30% engagement'],
      tags: ['Flutter', 'GetX', 'REST APIs'],
      link: 'https://play.google.com/store/search?q=athics&c=apps',
      linkLabel: 'Google Play',
      linkIcon: FontAwesomeIcons.googlePlay,
    ),
    Project(
      name: 'Medyaan Health',
      tagline:
          'Dental health app for viewing scan reports, booking appointments and managing referrals.',
      icon: Icons.health_and_safety_rounded,
      points: [
        'Implemented international mobile-number authentication (Flutter & Bloc), improving onboarding completion by 20%.',
        'Built doctor-wise appointment scheduling with cancel/reschedule and status filtering, cutting missed bookings by 25%.',
        'Delivered real-time push notifications and downloadable PDF scan reports, lifting patient show-up rate by 15% and cutting support queries by 30%.',
        'Enabled deep-link / WhatsApp referral sharing and auto-upgrade, growing referral-driven acquisition by 20%.',
      ],
      metrics: ['+20% onboarding', '-25% missed bookings', '-30% support'],
      tags: ['Flutter', 'Bloc', 'Push', 'Deep links'],
      link: 'https://play.google.com/store/apps/details?id=com.app.vogo_health',
      linkLabel: 'Google Play',
      linkIcon: FontAwesomeIcons.googlePlay,
    ),
  ];

  static const String degree = 'B.E. in Computer Science and Engineering';
  static const String college = 'Einstein College of Engineering, Tirunelveli';
  static const String degreeMeta = '2019 – 2023  ·  CGPA 7.8';

  static const List<List<String>> certifications = [
    ['Flutter Development Certification', 'Udemy · 2024'],
    ['Figma Essentials for UI/UX Design', 'Udemy · 2025'],
  ];
}
