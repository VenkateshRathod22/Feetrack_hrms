import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/account_screen/widget/account_option_section/account_option_model.dart';
import 'package:vlr/views/screens/account_screen/widget/account_option_section/account_option_widget.dart';

class AccountOptionSection extends StatelessWidget {
  const AccountOptionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      List<AccountOptionModel> filterList(
          List<AccountOptionModel> originalList) {
        List<AccountOptionModel> filtered = [];
        for (var item in originalList) {
          bool hasPermission = true;
          if (item.requiredPermission != null) {
            hasPermission =
                authController.hasPermission(item.requiredPermission!);
          }

          if (item.subItems != null && item.subItems!.isNotEmpty) {
            final filteredSubItems = filterList(item.subItems!);
            if (filteredSubItems.isNotEmpty) {
              filtered.add(AccountOptionModel(
                icon: item.icon,
                title: item.title,
                onTap: item.onTap,
                subItems: filteredSubItems,
                requiredPermission: item.requiredPermission,
              ));
            }
          } else if (hasPermission) {
            filtered.add(item);
          }
        }
        return filtered;
      }

      final list = filterList(accountOptionModelList(context: context));

      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: white,
              border: Border.all(
                width: 1,
                color: greyLight4,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: black.withValues(alpha: 0.05))
              ],
            ),
            child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final accountOptionModel = list[index];
                  return AccountOptionWidget(
                      accountOptionModel: accountOptionModel);
                },
                separatorBuilder: (_, __) => Divider(
                      color: greyLight1,
                      height: 1,
                      thickness: 1,
                    ),
                itemCount: list.length),
          ),
        ],
      );
    });
  }
}
