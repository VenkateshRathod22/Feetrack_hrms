import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/data/models/response/customer_visit_model.dart';
import 'package:vlr/data/models/response/lead_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateCustomerVisitScreen extends StatefulWidget {
  final CustomerVisitModel? visit;
  const CreateCustomerVisitScreen({super.key, this.visit});

  @override
  State<CreateCustomerVisitScreen> createState() => _CreateCustomerVisitScreenState();
}

class _CreateCustomerVisitScreenState extends State<CreateCustomerVisitScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<LeadController>();
      controller.getLeads(); // Ensure leads are available for selection
      if (widget.visit != null) {
        controller.setVisitData(widget.visit!);
      } else {
        controller.clearVisitControllers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          widget.visit != null ? "Update Visit" : "Schedule Visit",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: black),
        ),
      ),
      body: GetBuilder<LeadController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropDownList<LeadModel>(
                  heading: "Select Lead",
                  isRequired: true,
                  items: controller.leadsList,
                  value: controller.selectedLeadForVisit,
                  hintText: "Choose a lead",
                  onChanged: (val) {
                    controller.selectedLeadForVisit = val;
                    controller.update();
                  },
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Visit Date",
                  isRequired: true,
                  readOnly: true,
                  hindText: "YYYY-MM-DD",
                  controller: controller.visitDateController,
                  onTap: () => _selectDate(context, controller.visitDateController),
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Purpose",
                  hindText: "e.g. Meet, Demo, Closing",
                  controller: controller.visitPurposeController,
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Location",
                  hindText: "Enter visit location",
                  controller: controller.visitLocationController,
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Notes",
                  hindText: "Enter visit details...",
                  controller: controller.visitNotesController,
                  maxLines: 4,
                ),
                sizedBoxHeight(height: 40),
                CustomButton(
                  title: widget.visit != null ? "Update Visit" : "Schedule Visit",
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.visit != null) {
                        controller.updateCustomerVisit(widget.visit!.id!);
                      } else {
                        controller.addCustomerVisit();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
