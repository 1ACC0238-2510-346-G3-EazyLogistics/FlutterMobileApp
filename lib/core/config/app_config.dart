class AppConfig {
  // URL base del backend Spring Boot
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'http://localhost:8081/api', // Para emulador Android por defecto
  );

  // Entorno de la aplicación
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // Timeout para las peticiones HTTP (en segundos)
  static const int httpTimeoutSeconds = int.fromEnvironment(
    'HTTP_TIMEOUT',
    defaultValue: 30,
  );

  // Configuración de debug
  static const bool debugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: true,
  );

  // Versión de la API
  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  // Configuraciones derivadas
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isTesting => environment == 'testing';

  // URLs específicas para diferentes servicios
  static String get usersEndpoint => '$apiBaseUrl/users';
  static String get hotelsEndpoint => '$apiBaseUrl/hotels';
  static String get favoritesEndpoint => '$apiBaseUrl/favorites';
  static String get bookingsEndpoint => '$apiBaseUrl/bookings';
  static String get reviewsEndpoint => '$apiBaseUrl/reviews';

  // Headers comunes para las peticiones
  static Map<String, String> get commonHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'API-Version': apiVersion,
  };

  // Configuración de logs
  static void logConfig() {
    if (debugMode) {
      print('=== APP CONFIG ===');
      print('Environment: $environment');
      print('API Base URL: $apiBaseUrl');
      print('Debug Mode: $debugMode');
      print('HTTP Timeout: ${httpTimeoutSeconds}s');
      print('API Version: $apiVersion');
      print('==================');
    }
  }
}
