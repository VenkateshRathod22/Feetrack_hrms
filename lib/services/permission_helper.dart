import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';

bool hasPermission(dynamic permission) {
  if (permission == null) return true;
  if (permission is String && permission.isEmpty) return true;
  try {
    return Get.find<AuthController>().hasPermission(permission);
  } catch (e) {
    return true; 
  }
}

class PermissionWrapper extends StatelessWidget {
  final dynamic permission;
  final Widget child;
  const PermissionWrapper({super.key, this.permission, required this.child});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return authController.hasPermission(permission)
          ? child
          : const SizedBox.shrink();
    });
  }
}
