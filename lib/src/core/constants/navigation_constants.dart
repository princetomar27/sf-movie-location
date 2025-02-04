import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateTo(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  static void replaceWith(BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  static void navigateAndRemoveUntil(BuildContext context, Widget destination) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      debugPrint('No screens to pop!');
    }
  }

  static void goBackWithResult<T>(BuildContext context, T result) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    } else {
      debugPrint('No screens to pop with result!');
    }
  }
}
