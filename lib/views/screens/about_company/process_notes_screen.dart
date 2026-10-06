import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/about_company_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:flutter_html/flutter_html.dart';

class ProcessNotesScreen extends StatefulWidget {
  const ProcessNotesScreen({super.key});

  @override
  State<ProcessNotesScreen> createState() => _ProcessNotesScreenState();
}

class _ProcessNotesScreenState extends State<ProcessNotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AboutCompanyController>().getProcessNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Process Notes",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      body: GetBuilder<AboutCompanyController>(builder: (controller) {
        if (controller.isLoading && controller.processNotes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.processNotes.isEmpty) {
          return const Center(child: CustomText("No process notes found"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.getProcessNotes(),
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.processNotes.length,
            separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
            itemBuilder: (context, index) {
              final note = controller.processNotes[index];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: black.withValues(alpha: 0.04),
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
                        Icon(Icons.description_outlined, color: primaryColor, size: 20.sp),
                        sizedBoxWidth(width: 8),
                        Expanded(
                          child: CustomText(
                            note.title ?? "Untitled",
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: blackText1),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Html(
                      data: note.description ?? "",
                      style: {
                        "body": Style(
                          fontSize: FontSize(13.sp),
                          color: blackText2,
                          lineHeight: LineHeight.number(1.5),
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
