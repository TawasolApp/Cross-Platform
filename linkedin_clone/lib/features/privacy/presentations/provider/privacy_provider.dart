// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/block_user_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/get_blocked_list_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/report_post_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/report_user_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/unblock_user_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/entities/privacy_user_entity.dart';

class PrivacyProvider with ChangeNotifier {
  // Dependencies
  final BlockUserUseCase blockUserUseCase;
  final UnblockUserUseCase unblockUserUseCase;
  final GetBlockedListUseCase getBlockedListUseCase;
  final ReportPostUseCase reportPostUseCase;
  final ReportUserUseCase reportUserUseCase;

  // State
  List<PrivacyUserEntity>? blockedUsers;
  bool _isLoading = false;
  bool _isBusy = false;
  String? _error;
  bool? _reportReasonSelected = false;
  String? _reportReason;

  // Getters
  bool get isLoading => _isLoading;
  bool get isBusy => _isBusy;
  String? get error => _error;
  bool? get hasError => _error?.isNotEmpty;
  bool? get reportReasonSelected => _reportReasonSelected;
  String? get reportReason => _reportReason;
  set reportReason(String? value) {
    _reportReason = value;
    notifyListeners();
  }

  set reportReasonSelected(bool? value) {
    _reportReasonSelected = value;
    notifyListeners();
  }

  // Constructor
  PrivacyProvider({
    required this.blockUserUseCase,
    required this.unblockUserUseCase,
    required this.getBlockedListUseCase,
    required this.reportPostUseCase,
    required this.reportUserUseCase,
  });

  // Get blocked users
  Future<void> getBlockedUsers() async {
    if (_isBusy) return;
    _isBusy = true;
    _isLoading = true;
    try {
      _error = null;
      blockedUsers = await getBlockedListUseCase.call();
    } catch (e) {
      print('PrivacyProvider: getBlockedUsers error: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  // Block user
  Future<bool> blockUser(String userId) async {
    final success = await blockUserUseCase.call(userId);
    if (success) await getBlockedUsers();
    return success;
  }

  // Unblock user
  Future<bool> unblockUser(String userId) async {
    final success = await unblockUserUseCase.call(userId);
    if (success) await getBlockedUsers();
    return success;
  }

  Future<bool> reportPost(String postId) async {
    if (reportReason == null) return false;
    final success = await reportPostUseCase.call(postId, reportReason!);
    if (success) await getBlockedUsers();
    return success;
  }

  Future<bool> reportUser(String userId) async {
    if (reportReason == null) return false;
    final success = await reportUserUseCase.call(userId, reportReason!);
    if (success) await getBlockedUsers();
    return success;
  }
}
