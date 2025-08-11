abstract class AppConfig {
  abstract String baseUrl;
}

class DevConfiguration implements AppConfig {
  @override
  String baseUrl = 'https://otc-backend-mobile-1.onrender.com/';
}

class ProdConfiguration implements AppConfig {
  @override
  String baseUrl = '';
}
