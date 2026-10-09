import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/pipeline_stage_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/settings/add_pipline_config_screem.dart';

class PiplineConfigScreen extends StatefulWidget {
  const PiplineConfigScreen({super.key});

  @override
  State<PiplineConfigScreen> createState() => _PiplineConfigScreenState();
}

class _PiplineConfigScreenState extends State<PiplineConfigScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PipelineStageController>().getPipelineStageList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Pipeline Stages"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<PipelineStageController>().clearControllers();
          navigate(context: context, page: const AddPiplineConfigScreem());
        },
        backgroundColor: primaryColor,
        child:  Icon(Icons.add, color: white),
      ),
      body: GetBuilder<PipelineStageController>(builder: (pipelineController) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search stages...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  pipelineController.getPipelineStageList(search: val);
                },
              ),
            ),
            Expanded(
              child: pipelineController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : pipelineController.pipelineStageList.isEmpty
                      ? const Center(child: CustomText("No stages found"))
                      : ReorderableListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: pipelineController.pipelineStageList.length,
                          onReorder: (oldIndex, newIndex) {
                            // API doesn't seem to have a reorder endpoint in the description,
                            // but usually it's handled. For now, we just update local list.
                            if (newIndex > oldIndex) newIndex--;
                            final item = pipelineController.pipelineStageList.removeAt(oldIndex);
                            pipelineController.pipelineStageList.insert(newIndex, item);
                            pipelineController.update();
                          },
                          itemBuilder: (context, index) {
                            final stage = pipelineController.pipelineStageList[index];
                            return Container(
                              key: ValueKey(stage.id),
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
                                   Icon(Icons.drag_indicator, color: grey),
                                  sizedBoxWidth(width: 16.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          stage.name ?? "",
                                          style: Helper(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        sizedBoxHeight(height: 4.h),
                                        CustomText(
                                          "Dept: ${stage.department?.name ?? 'N/A'}",
                                          style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                        ),
                                        if (stage.countsTowardsTarget == true) ...[
                                          sizedBoxHeight(height: 4.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                              color: greenDark.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: CustomText(
                                              "Counts Towards Target",
                                              style: TextStyle(color: greenDark, fontSize: 10.sp),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      pipelineController.setEditData(stage);
                                      navigate(
                                        context: context,
                                        page: AddPiplineConfigScreem(isEdit: true, pipelineId: stage.id),
                                      );
                                    },
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialog(context, pipelineController, stage.id!);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
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

  void _showDeleteDialog(BuildContext context, PipelineStageController controller, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Stage"),
        content: Text("Are you sure you want to delete this pipeline stage?"),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deletePipelineStage(id).then((res) {
                showToast(message: res.message, typeCheck: res.isSuccess);
                pop(context);
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
