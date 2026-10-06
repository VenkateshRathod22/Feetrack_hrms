import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/expense_controller.dart';
import 'package:vlr/data/models/response/expense_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/views/screens/expence/apply_expence_screen.dart';

class ExpenceHistoryScreen extends StatefulWidget {
  const ExpenceHistoryScreen({super.key});

  @override
  State<ExpenceHistoryScreen> createState() => _ExpenceHistoryScreenState();
}

class _ExpenceHistoryScreenState extends State<ExpenceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ExpenseController>().fetchExpenses();
    });
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
          "Expense History",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
      ),
      body: GetBuilder<ExpenseController>(builder: (expenseController) {
        if (expenseController.isLoading && expenseController.expenseList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (expenseController.expenseList.isEmpty) {
          return Center(
            child: CustomText(
              "No expense history found",
              style: Helper(context).textTheme.bodyMedium,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await expenseController.fetchExpenses();
          },
          child: ListView.separated(
            padding: AppConstants.screenPadding,
            itemCount: expenseController.expenseList.length,
            separatorBuilder: (context, index) => sizedBoxHeight(height: 12.h),
            itemBuilder: (context, index) {
              ExpenseModel expense = expenseController.expenseList[index];
              return _ExpenseCard(expense: expense);
            },
          ),
        );
      }),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  const _ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (expense.status?.toLowerCase()) {
      case 'approved':
        statusColor = green;
        break;
      case 'rejected':
        statusColor = red;
        break;
      case 'pending':
      default:
        statusColor = yellow;
    }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  capitalize(expense.category ?? ""),
                  style: Helper(context).textTheme.labelSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  capitalize(expense.status ?? ""),
                  style: Helper(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (expense.status?.toLowerCase() == 'pending')
                IconButton(
                  onPressed: () {
                    navigate(context: context, page: ApplyExpenceScreen(expense: expense));
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          sizedBoxHeight(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Amount:",
                style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
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
          sizedBoxHeight(height: 8.h),
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
          sizedBoxHeight(height: 12.h),
          const Divider(),
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
