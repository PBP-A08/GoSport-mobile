class Urls {
  static const bool isDevelopment = false;

  static const String baseUrl = isDevelopment
      ? 'http://localhost:8000' // Local
      : 'https://sherin-khaira-football-site.pbp.cs.ui.ac.id'; // PWS Production

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
  static const String cartJson = '$baseUrl/cart/api/cart/';  
  static const String cartAdd = '$baseUrl/cart/api/cart/add/';
  static const String cartUpdate = '$baseUrl/cart/api/cart/update/';
  static const String cartDelete = '$baseUrl/cart/api/cart/remove/';

  static const String json = '$baseUrl/json/';

  static const String ratingJson = '$baseUrl/rating/json/';

  static const String transactionsJson = '$baseUrl/payment/transactions/json/';
}
