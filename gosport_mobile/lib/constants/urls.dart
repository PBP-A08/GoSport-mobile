class Urls {
  static const bool isDevelopment = false;

  static const String baseUrl = isDevelopment
      ? 'http://localhost:8000' // Local
      : 'https://sherin-khaira-football-site.pbp.cs.ui.ac.id'; // PWS Production

  // Auth endpoints
  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';

  // Profile endpoints
  static const String profileJson = '$baseUrl/profile/json/';
  static const String profileEdit = '$baseUrl/profile/edit-json/';
  static const String changePassword = '$baseUrl/profile/change-password/';
  static const String deleteAccount = '$baseUrl/profile/delete-json/';
}
