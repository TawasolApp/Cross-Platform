// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';

class PremiumRemoteDataSource {
  final http.Client client;
  final baseUrl = 'https://tawasolapp.me/api/';

  PremiumRemoteDataSource({required this.client});

  Future<String> initToken() async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    return token;
  }

  Future<String?> subscribeToPremiumPlan({
    required bool isYearly,
    required bool autoRenewal,
  }) async {
    try {
      print("isYearly: $isYearly, autoRenewal: $autoRenewal");
      String planType = isYearly ? "Yearly" : "Monthly";
      final token = await initToken();

      if (token == null) throw Exception("Token not found");
      final response = await http.post(
        Uri.parse("${baseUrl}premium-plan"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"planType": planType, "autoRenewal": autoRenewal}),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["checkoutSessionUrl"]; // This is the Stripe checkout URL
      } else if (response.statusCode == 409) {
        throw Exception(
          "subscribeToPremiumPlan: 409 User is already a premium plan user.",
        );
      } else if (response.statusCode == 401) {
        throw Exception("subscribeToPremiumPlanUser: 401 not authorized.");
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Premium request error: $e");
      return null;
    }
  }
}
