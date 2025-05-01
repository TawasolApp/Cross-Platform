import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/errors/exceptions.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/notifications/data/models/notifications_model.dart';
import 'package:linkedin_clone/features/notifications/data/data_sources/notifications_data_source.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class NotificationsRemoteDataSourceImpl implements NotificationDataSource {
  final String baseUrl;
  final _notificationsController = StreamController<NotificationsModel>.broadcast();

  NotificationsRemoteDataSourceImpl({required this.baseUrl});

  // Helper method to get authorization headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw UnauthorizedException('No authentication token found');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<NotificationsModel>> getNotifications(
    String id, {
    int page = 1,
    int limit = 10,
  }) async {
    final headers = await _getAuthHeaders();
    final uri = Uri.parse('$baseUrl/notifications/$id').replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> notificationsJson = json.decode(response.body);
      return notificationsJson
          .map((json) => NotificationsModel.fromJson(json))
          .toList();
    } else {
      throw ServerException('Failed to load notifications');
    }
  }

  @override
  Future<int> getUnseenNotificationsCount(String id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/$id/unseen'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['unseenCount'] as int;
    } else {
      throw ServerException('Failed to get unseen notifications count');
    }
  }

  @override
  Future<void> markNotificationAsRead(String id, String notificationId) async {
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/notifications/$id/$notificationId/read'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw ServerException('Failed to mark notification as read');
    }
  }

  @override
  Future<List<NotificationsModel>> getUnreadNotifications(
    String id, {
    int page = 1,
    int limit = 10,
  }) async {
    final headers = await _getAuthHeaders();
    final uri = Uri.parse('$baseUrl/notifications/$id/unread').replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> notificationsJson = json.decode(response.body);
      return notificationsJson
          .map((json) => NotificationsModel.fromJson(json))
          .toList();
    } else {
      throw ServerException('Failed to load notifications');
    }
  }

  // FCM Methods
  @override
  Future<String?> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      throw ServerException('Failed to get FCM token: $e');
    }
  }

  @override
  Future<void> initializeFcm() async {
    try {
      // Request permission for notifications
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null && message.data.isNotEmpty) {
          final notificationData = message.data;
          final notification = NotificationsModel.fromJson(notificationData);
          _notificationsController.add(notification);
        }
      });

      // Handle when app is in background but open
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data.isNotEmpty) {
          final notificationData = message.data;
          final notification = NotificationsModel.fromJson(notificationData);
          _notificationsController.add(notification);
        }
      });
    } catch (e) {
      throw ServerException('Failed to initialize FCM: $e');
    }
  }

  @override
  Stream<NotificationsModel> get notificationStream => _notificationsController.stream;

  @override
  Future<void> subscribeToNotifications(String id) async {
    try {
      final headers = await _getAuthHeaders();
      final apiRoute = Uri.parse('$baseUrl/notifications/$id/subscribe-fcm');

      // Request notification permission
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Get FCM token
      String? token;
      if (kIsWeb) {
        token = await FirebaseMessaging.instance.getToken(
          vapidKey: 'BAdGRmpnjgGsXy9_i4y3i925ouEiNmZ-YDcQ4vU3uEZG42Xgj_asv9AQMfzXlHjizQctOcip7kMgqMtMyo_Jmc4', // <-- Replace if needed
        );
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }

      if (token == null) {
        throw ServerException('Failed to get FCM token');
      }
      print('FCM Token: $token');
      final body = jsonEncode({"fcmToken": token});

      final response = await http.post(
        apiRoute,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: ${response.body}');
      } else {
        throw ServerException('Failed to subscribe to notifications: ${response.body}');
      }
    } catch (e) {
      if (e is UnauthorizedException) {
        rethrow;
      }
      throw ServerException('Failed to subscribe to notifications: $e');
    }
  }
}