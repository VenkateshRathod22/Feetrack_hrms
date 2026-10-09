import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/expense_controller.dart';
import 'package:vlr/data/models/response/expense_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/generated/assets.dart';

class ExpenceApprovalsScreen extends StatefulWidget {
  const ExpenceApprovalsScreen({super.key});

  @override
  State<ExpenceApprovalsScreen> createState() => _ExpenceApprovalsScreenState();
}

class _ExpenceApprovalsScreenState extends State<ExpenceApprovalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ExpenseController>().fetchTeamExpenses('pending');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: white,
        title: CustomText(
          "Expense Approvals",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
      ),
      body: GetBuilder<ExpenseController>(builder: (expenseController) {
        if (expenseController.isLoading && expenseController.teamExpenseList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (expenseController.teamExpenseList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 60.sp, color: grey),
                sizedBoxHeight(height: 16.h),
                CustomText(
                  "No pending expense requests",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(color: grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await expenseController.fetchTeamExpenses('pending');
          },
          child: ListView.separated(
            padding: AppConstants.screenPadding,
            itemCount: expenseController.teamExpenseList.length,
            separatorBuilder: (context, index) => sizedBoxHeight(height: 16.h),
            itemBuilder: (context, index) {
              ExpenseModel expense = expenseController.teamExpenseList[index];
              return _ApprovalCard(expense: expense);
            },
          ),
        );
      }),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final ExpenseModel expense;
  const _ApprovalCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    final expenseController = Get.find<ExpenseController>();
    
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImage(
                path: expense.employee?.profileImage ?? Assets.imagesNoProfile,
                height: 50.h,
                width: 50.w,
                radius: 999,
                isProfile: true,
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      expense.employee?.name ?? "Unknown",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    CustomText(
                      "Applied for ${capitalize(expense.category ?? "")}",
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            color: primaryColor,
                            fontSize: 12.sp,
                          ),
                    ),
                  ],
                ),
              ),
              CustomText(
                PriceConverter.convertToNumberFormat(double.tryParse(expense.amount ?? "0") ?? 0),
                style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontSize: 16.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12.h),
          const Divider(),
          sizedBoxHeight(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Date:",
                style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
              ),
              CustomText(
                expense.date != null ? _formatDate(expense.date!) : "--",
                style: Helper(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          sizedBoxHeight(height: 8.h),
          CustomText(
            "Description:",
            style: Helper(context).textTheme.titleSmall?.copyWith(fontSize: 12.sp),
          ),
          sizedBoxHeight(height: 4.h),
          CustomText(
            expense.description ?? "No description provided",
            style: Helper(context).textTheme.bodySmall?.copyWith(
                  color: greyText,
                  fontSize: 12.sp,
                ),
          ),
          sizedBoxHeight(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: expenseController.isLoading ? null : () {
                    _showConfirmationDialog(context, "rejected");
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: red,
                    side:  BorderSide(color: red),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text("Reject"),
                ),
              ),
              sizedBoxWidth(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: expenseController.isLoading ? null : () {
                    _showConfirmationDialog(context, "approved");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text("Approve"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${capitalize(status)} Expense"),
        content: Text("Are you sure you want to ${status.toLowerCase()} this expense request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<ExpenseController>().updateExpenseStatus(expense.id!, status, currentTabStatus: 'pending');
            },
            child: Text(capitalize(status), style: TextStyle(color: status == 'approved' ? green : red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormatters().dMy.format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}
