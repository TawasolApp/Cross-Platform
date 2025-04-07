import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<String> getUserId() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not available');
    }

    // Extract user ID from token (implementation depends on your token structure)
    // For example, if using JWT:
    // final parts = token.split('.');
    // if (parts.length != 3) {
    //   throw Exception('Invalid token format');
    // }
    // final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    // return payload['userId'] as String;

    // Placeholder - replace with actual implementation
    return "current-user-id";
  }
}
