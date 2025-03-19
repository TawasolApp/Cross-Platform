import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _bio = '';
  String _profilePictureUrl = '';
  String _occupation = '';
  String _address = '';
  int _connections = 0;

  String get name => _name;
  String get email => _email;
  String get bio => _bio;
  String get profilePictureUrl => _profilePictureUrl;
  String get occupation => _occupation;
  String get address => _address;
  int get connections => _connections;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void setProfilePictureUrl(String url) {
    _profilePictureUrl = url;
    notifyListeners();
  }

  void setOccupation(String occupation) {
    _occupation = occupation;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setConnections(int connections) {
    _connections = connections;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String email,
    required String bio,
    required String profilePictureUrl,
    required String occupation,
    required String address,
    required int connections,
  }) {
    _name = name;
    _email = email;
    _bio = bio;
    _profilePictureUrl = profilePictureUrl;
    _occupation = occupation;
    _address = address;
    _connections = connections;
    notifyListeners();
  }
}