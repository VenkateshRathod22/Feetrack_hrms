import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/holiday_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/settings/add_holyday_screen.dart';

class HolydaysScreen extends StatefulWidget {
  const HolydaysScreen({super.key});

  @override
  State<HolydaysScreen> createState() => _HolydaysScreenState();
}

class _HolydaysScreenState extends State<HolydaysScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HolidayController>().getHolidayList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("Holidays"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<HolidayController>().clearControllers();
          navigate(context: context, page: const AddHolydayScreen());
        },
        backgroundColor: primaryColor,
        child:  Icon(Icons.add, color: white),
      ),
      body: GetBuilder<HolidayController>(builder: (holidayController) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search holidays...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  holidayController.getHolidayList(search: val);
                },
              ),
            ),
            Expanded(
              child: holidayController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : holidayController.holidayList.isEmpty
                      ? const Center(child: CustomText("No holidays found"))
                      : ListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: holidayController.holidayList.length,
                          itemBuilder: (context, index) {
                            final holiday = holidayController.holidayList[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: grey.withValues(alpha: 0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          holiday.name ?? "",
                                          style: Helper(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        sizedBoxHeight(height: 4.h),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today, size: 14.sp, color: grey),
                                            sizedBoxWidth(width: 4.w),
                                            CustomText(
                                              holiday.date ?? "",
                                              style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                            ),
                                          ],
                                        ),
                                        if (holiday.branch?.name != null) ...[
                                          sizedBoxHeight(height: 4.h),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, size: 14.sp, color: grey),
                                              sizedBoxWidth(width: 4.w),
                                              CustomText(
                                                holiday.branch?.name ?? "",
                                                style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      holidayController.setEditData(holiday);
                                      navigate(
                                        context: context,
                                        page: AddHolydayScreen(isEdit: true, holidayId: holiday.id),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialog(context, holidayController, holiday.id!);
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, HolidayController controller, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Holiday"),
        content: const Text("Are you sure you want to delete this holiday?"),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteHoliday(id).then((res) {
                showToast(message: res.message, typeCheck: res.isSuccess);
                pop(context);
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
