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

class TeamExpencesScreen extends StatefulWidget {
  const TeamExpencesScreen({super.key});

  @override
  State<TeamExpencesScreen> createState() => _TeamExpencesScreenState();
}

class _TeamExpencesScreenState extends State<TeamExpencesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchExpenses();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExpenses();
    });
  }

  void _fetchExpenses() {
    String status = 'pending';
    if (_tabController.index == 1) {
      status = 'approved';
    } else if (_tabController.index == 2) {
      status = 'rejected';
    }
    Get.find<ExpenseController>().fetchTeamExpenses(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: white,
        title: CustomText(
          "Team Expenses",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: grey,
          indicatorColor: primaryColor,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Approved"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: GetBuilder<ExpenseController>(builder: (expenseController) {
        if (expenseController.isLoading && expenseController.teamExpenseList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (expenseController.teamExpenseList.isEmpty) {
          return Center(
            child: CustomText(
              "No expense requests found",
              style: Helper(context).textTheme.bodyMedium,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _fetchExpenses();
          },
          child: ListView.separated(
            padding: AppConstants.screenPadding,
            itemCount: expenseController.teamExpenseList.length,
            separatorBuilder: (context, index) => sizedBoxHeight(height: 12.h),
            itemBuilder: (context, index) {
              ExpenseModel expense = expenseController.teamExpenseList[index];
              return _TeamExpenseCard(
                expense: expense,
                onStatusUpdate: () => _fetchExpenses(),
              );
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _TeamExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onStatusUpdate;
  const _TeamExpenseCard({required this.expense, required this.onStatusUpdate});

  @override
  Widget build(BuildContext context) {
    final expenseController = Get.find<ExpenseController>();
    bool isPending = expense.status?.toLowerCase() == 'pending';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
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
                height: 45.h,
                width: 45.w,
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
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    CustomText(
                      capitalize(expense.category ?? ""),
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
                      fontSize: 15.sp,
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
          if (isPending) ...[
            sizedBoxHeight(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: expenseController.isLoading
                        ? null
                        : () {
                            _showConfirmationDialog(context, "rejected");
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: red,
                      side: const BorderSide(color: red),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: const Text("Reject"),
                  ),
                ),
                sizedBoxWidth(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: expenseController.isLoading
                        ? null
                        : () {
                            _showConfirmationDialog(context, "approved");
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: const Text("Approve"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${capitalize(status)} Expense"),
        content: Text(
            "Are you sure you want to ${status.toLowerCase()} this expense request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<ExpenseController>().updateExpenseStatus(expense.id!, status,
                  currentTabStatus: expense.status);
            },
            child: Text(capitalize(status),
                style: TextStyle(
                    color: status == 'approved' ? green : red)),
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
