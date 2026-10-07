import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vlr/services/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchHelper {
  static Future<void> callUs({required String number}) async {
    final uri = Uri(scheme: 'tel', path: '+91$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // optionally show toast/snackbar
      debugPrint('Could not launch phone dialer');
    }
  }

  static Future<void> emailUs({required String email}) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  static Future<void> launchInstagram({
    required String username,
  }) async {
    final Uri appUri = Uri.parse("instagram://user?username=$username");

    final Uri webUri = Uri.parse("https://www.instagram.com/$username");

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> launchWhatsApp({
    required String phone,
    String message = "",
  }) async {
    final whatsappNumber = phone.replaceAll(" ", "").replaceAll("+", "");

    // WhatsApp app deep link
    final Uri appUri = Uri.parse(
        "whatsapp://send?phone=+91 $whatsappNumber&text=${Uri.encodeComponent(message)}");

    // WhatsApp Web fallback
    final Uri webUri = Uri.parse(
        "https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}");

    // Try app first
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      // fallback to web
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> launchUpiViaSystemChooser(String qrString) async {
    final uri = Uri.parse(qrString);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      showToast(message: 'No UPI app found or cannot open', typeCheck: false);
    } else {}
  }

  static Future<void> openGoogleMap({
    required String lat,
    required String lng,
  }) async {
    log("Location: $lat, $lng");

    // Empty or placeholder validation
    if (lat.trim().isEmpty ||
        lng.trim().isEmpty ||
        lat.trim() == "--" ||
        lng.trim() == "--") {
      showToast(
        message: "Location is not available",
        toastType: ToastType.warning,
      );
      return;
    }

    // Validate coordinates
    final latitude = double.tryParse(lat.trim());
    final longitude = double.tryParse(lng.trim());

    if (latitude == null || longitude == null) {
      showToast(
        message: "Invalid location coordinates",
        toastType: ToastType.warning,
      );
      return;
    }

    // Check valid GPS range
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      showToast(
        message: "Invalid location coordinates",
        toastType: ToastType.warning,
      );
      return;
    }

    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );

    if (!await canLaunchUrl(uri)) {
      showToast(
        message: "Unable to open Google Maps",
        toastType: ToastType.error,
      );
      return;
    }

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
