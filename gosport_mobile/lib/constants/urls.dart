class Urls {
  static const bool isDevelopment = true;

  static const String baseUrl = isDevelopment
      ? 'http://localhost:8000' // Local
      : 'http://sherin-khaira-football-site.pbp.cs.ui.ac.id'; // PWS Production

  // Auth endpoints
  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';
  static const String logout = '$baseUrl/auth/logout/';

  // Profile endpoints
  static const String profileJson = '$baseUrl/profile/json/';
  static const String profileEdit = '$baseUrl/profile/edit-json/';
  static const String changePassword = '$baseUrl/profile/change-password/';
  static const String deleteAccount = '$baseUrl/profile/delete-json/';

  // Cart endpoints
  static const String cartJson = '$baseUrl/cart/json/';
  static const String cartUpdate = '$baseUrl/cart/update/';
  static const String cartDelete = '$baseUrl/cart/delete/';

  static const String json = '$baseUrl/json/';
}
