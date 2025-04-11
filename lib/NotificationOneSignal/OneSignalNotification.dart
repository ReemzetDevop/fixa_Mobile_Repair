import 'dart:convert';
import 'package:http/http.dart' as http;

class PushOneSignalNotification {
  final String restApiKey = 'os_v2_app_rqrwxpjk6fdmxanvft7scwpdr6a7wwbhixhuwfn44p3lce2izmmn5galv27jg46dsyppuaxgiciabcn7roaivzwcjlcaotoshvvxlza';
  final String appId = '8c236bbd-2af1-46cb-81b5-2cff2159e38f';
  final String apiUrl = 'https://onesignal.com/api/v1/notifications';

  PushOneSignalNotification();

  Future<void> sendPushNotification({
    required String message,
    required String title,
    required String heading,
    required List<String> externalIds,
    required String targetChannel,
    required Map<String, dynamic> customData,
    String? imageUrl,
  }) async {
    // Data for the push notification
    final Map<String, dynamic> notificationData = {
      "app_id": appId,
      "contents": {
        "en": message,
        "es": message,
      },
      "headings": {
        "en": heading,
        "es": heading,
      },
      "include_external_user_ids": externalIds,
      "target_channel": targetChannel,
      "data": customData,
      "big_picture": imageUrl, // Include image URL if provided
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Basic $restApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
        print('Push notification sent successfully');
      } else {
        print('Failed to send push notification. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error sending push notification: $error');
    }
  }
}
