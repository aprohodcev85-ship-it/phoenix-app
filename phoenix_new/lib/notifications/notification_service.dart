import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> init() async {
    debugPrint('NotificationService initialized');
  }

  static Future<void> subscribeToTopic(String topic) async {
    debugPrint('Subscribed to topic: $topic');
  }

  static void showLocalNotification(String title, String body) {
    debugPrint('Notification: $title - $body');
  }
}