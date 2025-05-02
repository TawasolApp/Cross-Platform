import 'package:flutter/material.dart';

enum ChoiceListType { report, premium }

class PremiumProvider with ChangeNotifier {
  bool _optionSelected = false;
  bool get optionSelected => _optionSelected;
  set optionSelected(bool value) {
    _optionSelected = value;
    notifyListeners();
  }

  PremiumProvider();
}
