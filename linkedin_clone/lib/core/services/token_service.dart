import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _companyIdKey = 'company_id';
  static const _isCompany = 'is_company';
  static const _isAdmin = 'is_admin';


  static Future<void> saveIsAdmin(bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAdmin, isAdmin);
  }
  static Future<bool?> getIsAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdmin);
  }
  static Future<void> saveCompanyId(String companyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_companyIdKey, companyId);
  }
  static Future<String?> getCompanyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_companyIdKey);
  }
  static Future<void> saveIsCompany(bool isCompany) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isCompany, isCompany);
  }
  static Future<bool?> getIsCompany() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isCompany);
  }
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }
  static Future<String?> getUserId(){
    final prefs = SharedPreferences.getInstance();
    return prefs.then((prefs) => prefs.getString(_userIdKey));
  }
  static Future<void> saveToken(String token) async {
    print("Token saved is=  $token***********  ");
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
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
  static Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
  static Future<void> removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('refresh_token');
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }


}
