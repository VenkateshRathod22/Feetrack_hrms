import 'package:flutter/widgets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/attendance/attendance_history/attendance_history_screen.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/team_attendance_history_screen.dart';
import 'package:vlr/views/screens/attendance/today_team_attendance/today_team_attendance_screen.dart';
import 'package:vlr/views/screens/edit_profile/profile_detail_screen.dart';
import 'package:vlr/views/screens/expence/apply_expence_screen.dart';
import 'package:vlr/views/screens/expence/expence_approvals_screen.dart';
import 'package:vlr/views/screens/expence/expence_history_screen.dart';
import 'package:vlr/views/screens/expence/team_expences_screen.dart';
import 'package:vlr/views/screens/leave/apply_leave/apply_leave_screen.dart';
import 'package:vlr/views/screens/leave/leave_approvals_screen.dart';
import 'package:vlr/views/screens/leave/leave_category_screen.dart';
import 'package:vlr/views/screens/leave/leave_history.dart';
import 'package:vlr/views/screens/leave/team_leave_status_screen.dart';
import 'package:vlr/views/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:vlr/views/screens/staff/staff_screen.dart';
import 'package:vlr/views/screens/category/category_screen.dart';
import 'package:vlr/views/screens/category/create_category_screen.dart';
import 'package:vlr/views/screens/product/product_screen.dart';
import 'package:vlr/views/screens/product/create_product_screen.dart';
import 'package:vlr/views/screens/work_shift/work_shift_screen.dart';
import 'package:vlr/views/screens/work_shift/create_work_shift_screen.dart';
import 'package:vlr/views/screens/role/role_screen.dart';
import 'package:vlr/views/screens/role/create_role_screen.dart';
import 'package:vlr/views/screens/settings/settings_screen.dart';
import 'package:vlr/views/screens/about_company/company_documents_screen.dart';
import 'package:vlr/views/screens/about_company/process_notes_screen.dart';

class AccountOptionModel {
  final String icon;
  final String title;
  final Function()? onTap;
  final List<AccountOptionModel>? subItems;
  final dynamic requiredPermission;

  AccountOptionModel({
    required this.icon,
    required this.title,
    this.onTap,
    this.subItems,
    this.requiredPermission,
  });
}

List<AccountOptionModel> accountOptionModelList(
        {required BuildContext context}) =>
    [
      AccountOptionModel(
          icon: Assets.svgsPerson2,
          title: "Personal Information",
          onTap: () {
            navigate(context: context, page: ProfileDetailScreen());
          }),
      AccountOptionModel(
          icon: Assets.svgsCalender,
          title: "Team Leave",
          subItems: [
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Apply Leave",
                requiredPermission: "leave_create",
                onTap: () {
                  navigate(context: context, page: const ApplyLeaveScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Team Leave Status",
                requiredPermission: ["leave_viewteam", "leave_viewany"],
                onTap: () {
                  navigate(
                      context: context, page: const TeamLeaveStatusScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Leave Category",
                requiredPermission: ["leave_viewteam", "leave_viewany", "leavecategory_viewany"],
                onTap: () {
                  navigate(
                      context: context, page: const LeaveCategoryScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Leave History",
                requiredPermission: ["leave_viewown", "leave_viewany"],
                onTap: () {
                  navigate(context: context, page: const LeaveHistoryScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Leave Approvals",
                requiredPermission: ["leave_update", "leave_status_update"],
                onTap: () {
                  navigate(
                      context: context, page: const LeaveApprovalsScreen());
                }),
          ]),
      AccountOptionModel(
          icon: Assets.svgsCalender,
          title: "Expense",
          subItems: [
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Apply Expense",
                requiredPermission: "expense_create",
                onTap: () {
                  navigate(context: context, page: const ApplyExpenceScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Team Expense Status",
                requiredPermission: ["expense_viewteam", "expense_viewany"],
                onTap: () {
                  navigate(
                      context: context, page: const TeamExpencesScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Expense History",
                requiredPermission: ["expense_viewown", "expense_viewany"],
                onTap: () {
                  navigate(context: context, page: const ExpenceHistoryScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Expense Approvals",
                requiredPermission: ["expense_update", "expense_status_update"],
                onTap: () {
                  navigate(
                      context: context, page: const ExpenceApprovalsScreen());
                }),
          ]),

      
      AccountOptionModel(
          icon: Assets.svgsClock,
          title: "Attendance History",
          requiredPermission: ["attendance_viewown", "attendance_viewany"],
          onTap: () {
            navigate(context: context, page: const AttendanceHistoryScreen());
          }),
      AccountOptionModel(
          icon: Assets.svgsClock,
          title: "Today Team Attendance",
          requiredPermission: ["attendance_viewteam", "attendance_viewany"],
          onTap: () {
            navigate(context: context, page: const TodayTeamAttendanceScreen());
          }),
      AccountOptionModel(
          icon: Assets.svgsClock,
          title: "Team Attendance History",
          requiredPermission: ["attendance_viewteam", "attendance_viewany"],
          onTap: () {
            navigate(
                context: context, page: const TeamAttendanceHistoryScreen());
          }),
      AccountOptionModel(
          icon: Assets.svgsNotification, title: "Notifications", onTap: () {

      }),
      AccountOptionModel(
          icon: Assets.svgsPrivacyPolicy,
          title: "Privacy Policy",
          onTap: () {
            navigate(context: context, page: const PrivacyPolicyScreen());
          }),
      AccountOptionModel(
          icon: Assets.svgsPrivacyPolicy,
          title: "Staff Management",
          requiredPermission: ["staff_viewany", "staff_viewown"],
          onTap: () {
            navigate(context: context, page: const StaffScreen());
          }),
      AccountOptionModel(
          icon: Assets.svgsCalender,
          title: "Category Management",
          subItems: [
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Create Category",
                requiredPermission: "category_create",
                onTap: () {
                  navigate(context: context, page: const CreateCategoryScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Categories",
                requiredPermission: "category_viewany",
                onTap: () {
                  navigate(context: context, page: const CategoryScreen());
                }),
          ]),
      AccountOptionModel(
          icon: Assets.svgsCalender,
          title: "Product Management",
          subItems: [
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Create Product",
                requiredPermission: "product_create",
                onTap: () {
                  navigate(context: context, page: const CreateProductScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsCalender,
                title: "Products",
                // requiredPermission: "product_viewany",
                onTap: () {
                  navigate(context: context, page: const ProductScreen());
                }),
          ]),
      AccountOptionModel(
          icon: Assets.svgsClock,
          title: "Work Shift Management",
          subItems: [
            AccountOptionModel(
                icon: Assets.svgsClock,
                title: "Create Work Shift",
                requiredPermission: ["shift_create", "work_shift_create"],
                onTap: () {
                  navigate(context: context, page: const CreateWorkShiftScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsClock,
                title: "Work Shifts",
                requiredPermission: ["shift_viewany", "work_shift_viewany"],
                onTap: () {
                  navigate(context: context, page: const WorkShiftScreen());
                }),
          ]),
      AccountOptionModel(
          icon: Assets.svgsPrivacyPolicy,
          title: "Role Management",
          subItems: [
            AccountOptionModel(
                icon: Assets.svgsPrivacyPolicy,
                title: "Create Role",
                requiredPermission: "role_create",
                onTap: () {
                  navigate(context: context, page: const CreateRoleScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsPrivacyPolicy,
                title: "Roles",
                requiredPermission: "role_viewany",
                onTap: () {
                  navigate(context: context, page: const RoleScreen());
                }),
          ]),
      AccountOptionModel(
          icon: Assets.svgsPrivacyPolicy,
          title: "About Company & Notes",
          subItems: [
            AccountOptionModel(
                icon: Assets.svgsPrivacyPolicy,
                title: "Company Documents",
                onTap: () {
                  navigate(context: context, page: const CompanyDocumentsScreen());
                }),
            AccountOptionModel(
                icon: Assets.svgsPrivacyPolicy,
                title: "Process Notes",
                onTap: () {
                  navigate(context: context, page: const ProcessNotesScreen());
                }),
          ]),
      AccountOptionModel(
          icon: Assets.svgsInfo,
          title: "Settings",
          // requiredPermission: "holiday_viewany",
          onTap: () {
            navigate(context: context, page:  SettingsScreen());
          }),
      AccountOptionModel(
          icon: Assets.svgsHelpAndSupport,
          title: "Help & Support",
          onTap: () {}),
      AccountOptionModel(
          icon: Assets.svgsTermAndCondition,
          title: "Terms & Conditions",
          onTap: () {}),
    ];
