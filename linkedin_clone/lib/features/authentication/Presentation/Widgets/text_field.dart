import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType; 
  final bool isPassword;
  final Function(String) onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    this.isPassword = false,
    required this.onChanged,
    this.contentPadding,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      keyboardType: keyboardType,
      obscureText: isPassword,
      onChanged: onChanged,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        hintStyle: TextStyle(color: theme.hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}
