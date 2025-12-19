import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class AppUtils {
  // Date formatting utilities
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  // Validation utilities
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(phone);
  }

  // UI utilities
  static void showSnackBar(BuildContext context, String message,
      {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, color: AppColors.errorColor);
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, color: AppColors.successColor);
  }

  static void showTopSnackBar(BuildContext context, String message,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppColors.infoColor,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 0,
          left: 16,
          right: 16,
          top: 8,
        ),
      ),
    );
  }

  // String utilities
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Precaches an asset image for smooth loading
  static Future<void> precacheAssetImage(
      BuildContext context, String assetPath) {
    return precacheImage(AssetImage(assetPath), context);
  }

  /// Precaches multiple asset images in parallel
  static Future<void> precacheAssetImages(
      BuildContext context, List<String> assetPaths) {
    return Future.wait(
      assetPaths.map((path) => precacheImage(AssetImage(path), context)),
    );
  }
}
