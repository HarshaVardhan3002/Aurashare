class AppConstants {
  // App Info
  static const String appName = 'AuraShare';
  static const String appVersion = '1.0.0';

  // API & Firebase
  static const String firebaseProjectId = 'aurashare-app';

  // UI Constants
  static const double maxImageWidth = 1080;
  static const double maxImageHeight = 1080;
  static const int maxCaptionLength = 280;
  static const int postsPerPage = 20;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Image Placeholders
  static const String placeholderImageUrl =
      'https://via.placeholder.com/400x400/E5E5EA/8E8E93?text=AuraShare';
  static const String placeholderAvatarUrl =
      'https://via.placeholder.com/100x100/6B73FF/FFFFFF?text=A';
}
