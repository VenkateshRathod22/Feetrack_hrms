import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/controllers/payslip_config_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/views/screens/settings/attendence_check_list_point_screen.dart';
import 'package:vlr/views/screens/settings/get_commision_level_screen.dart';
import 'package:vlr/views/screens/settings/get_payslip_config_screen.dart';
import 'package:vlr/views/screens/settings/holydays_screen.dart';
import 'package:vlr/views/screens/settings/pipline_config_screen.dart';
import 'package:vlr/views/screens/settings/theme_settings_screen/theme_settings_screen.dart';

import '../task/task_status_screen.dart';
import 'expence_category_screen.dart';
import 'leave_category_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // if (authController.hasPermission("holiday_viewany"))
              _buildSettingsTile(
                context: context,
                icon: Icons.calendar_month_outlined,
                title: "Holidays",
                subtitle: "Manage company holidays",
                onTap: () {
                  navigate(context: context, page: const HolydaysScreen());
                },
              ),
            // if (authController.hasPermission("holiday_viewany"))
              const SizedBox(height: 12),
            // if (authController.hasPermission("commission_level_viewany"))
              _buildSettingsTile(
                context: context,
                icon: Icons.monetization_on_outlined,
                title: "Commission Level",
                subtitle: "Manage commission levels",
                onTap: () {
                  navigate(
                      context: context, page: const GetCommisionLevelScreen());
                },
              ), _buildSettingsTile(
                context: context,
                icon: Icons.monetization_on_outlined,
                title: "Task Status",
                subtitle: "Manage commission levels",
                onTap: () {
                  navigate(
                      context: context, page: const TaskStatusScreen());
                },
              ),
            // if (authController.hasPermission("pipeline_config_viewany"))
              _buildSettingsTile(
                context: context,
                icon: Icons.account_tree_outlined,
                title: "Pipeline Config",
                subtitle: "Manage pipeline stages",
                onTap: () {
                  navigate(context: context, page: const PiplineConfigScreen());
                },
              ),
            // if (authController.hasPermission("leave_category_viewany"))
              _buildSettingsTile(
                context: context,
                icon: Icons.category_outlined,
                title: "Leave Category",
                subtitle: "Manage leave categories",
                onTap: () {
                  navigate(context: context, page: const LeaveCategoryScreen());
                },
              ),
            // if (authController.hasPermission("expense_category_viewany"))
              _buildSettingsTile(
                context: context,
                icon: Icons.money_off_outlined,
                title: "Expense Category",
                subtitle: "Manage expense categories",
                onTap: () {
                  navigate(
                      context: context, page: const ExpenceCategoryScreen());
                },
              ),
            // if (authController.hasPermission("attendance_checklist_viewany"))
              const SizedBox(height: 12),
            // if (authController.hasPermission("attendance_checklist_viewany"))
              _buildSettingsTile(
                context: context,
                icon: Icons.checklist_outlined,
                title: "Attendance Checklist",
                subtitle: "Manage attendance settings",
                onTap: () {
                  navigate(
                      context: context,
                      page: const AttendenceCheckListPointScreen());
                },
              ),
            // if (authController.hasPermission("payslip_config_viewany"))
              _buildSettingsTile(
                context: context,
                icon: Icons.receipt_long_outlined,
                title: "Payslip Configuration",
                subtitle: "Manage payslip settings",
                onTap: () {
                  Get.find<PayslipConfigController>()
                      .getPayslipConfig()
                      .then((res) {
                    if (res.isSuccess) {
                      navigate(
                          context: context,
                          page: const GetPayslipConfigScreen());
                    } else {
                      showToast(message: res.message);
                    }
                  });
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.color_lens_outlined,
                title: "App theme",
                subtitle:  Get.isDarkMode ? "Dark" : "Light",
                onTap: () {

                 
                      navigate(
                          context: context,
                          page: const ThemeSettingsScreen());

                },
              ),
          ],
        ),
      );
    });
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}