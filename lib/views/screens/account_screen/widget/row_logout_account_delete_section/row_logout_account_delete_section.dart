import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/views/screens/account_screen/widget/row_logout_account_delete_section/row_logout_delete_account_widget.dart';
import 'package:vlr/views/screens/auth_screens/sign_in_screen.dart';

class RowOfLogOutAndDeleteAccountSection extends StatelessWidget {
  const RowOfLogOutAndDeleteAccountSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Row(
        children: [
          Expanded(
            child: RowOfLogOutAndDeleteAccountWIdget(
              icon: Icons.logout_outlined,
              title: "Logout",
              onTap: () {
                if (authController.isLoading) {
                  return showToast(
                      message: "Please wait..", toastType: ToastType.info);
                }
                authController.logOutPost().then((value) {
                  if (value.isSuccess) {
                    navigate(
                        context: context,
                        isRemoveUntil: true,
                        page: SignInScreen());
                    showToast(
                        message: value.message, typeCheck: value.isSuccess);
                  } else {
                    showToast(
                        message: value.message, typeCheck: value.isSuccess);

                    log(value.message);
                  }
                });
              },
            ),
          ),
          sizedBoxWidth(width: 12.w),
          Expanded(
            child: RowOfLogOutAndDeleteAccountWIdget(
              icon: Icons.delete_forever_outlined,
              title: "Delete Account",
              onTap: () {
                if (authController.isLoading) {
                  return showToast(
                      message: "Please wait..", toastType: ToastType.info);
                }
                authController.accountDelete().then((value) {
                  if (value.isSuccess) {
                    navigate(
                        context: context,
                        isRemoveUntil: true,
                        page: SignInScreen());
                    showToast(
                        message: value.message, typeCheck: value.isSuccess);
                  } else {
                    showToast(
                        message: value.message, typeCheck: value.isSuccess);

                    log(value.message);
                  }
                });
              },
            ),
          ),
        ],
      );
    });
  }
}
