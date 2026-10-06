import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/models/response/task_status_model.dart';
import 'package:vlr/data/repositories/task_repo.dart';
import 'package:vlr/services/constants.dart';

class TaskStatusController extends GetxController implements GetxService {
  final TaskRepo taskRepo;
  TaskStatusController({required this.taskRepo});

  bool isLoading = false;
  List<TaskStatusModel> taskStatusList = [];
  
  final TextEditingController nameController = TextEditingController();
  TaskStatusModel? selectedStatus;

  Future<void> getTaskStatuses({String? search}) async {
    isLoading = true;
    update();
    
    Response response = await taskRepo.getTaskStatuses(search: search);
    if (response.statusCode == 200 && response.body['status'] == "success") {
      taskStatusList = [];
      final List data = response.body['data'];
      for (var item in data) {
        taskStatusList.add(TaskStatusModel.fromJson(item));
      }
    }
    
    isLoading = false;
    update();
  }

  Future<ResponseModel> addTaskStatus() async {
    if (nameController.text.isEmpty) {
      return ResponseModel(false, "Please enter status name");
    }
    
    isLoading = true;
    update();
    
    Response response = await taskRepo.addTaskStatus({"name": nameController.text.trim()});
    isLoading = false;
    update();
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      nameController.clear();
      getTaskStatuses();
      return ResponseModel(true, response.body['message'] ?? "Status added successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to add status");
    }
  }

  Future<ResponseModel> updateTaskStatus() async {
    if (selectedStatus == null || nameController.text.isEmpty) {
      return ResponseModel(false, "Invalid input");
    }
    
    isLoading = true;
    update();
    
    Response response = await taskRepo.updateTaskStatus(selectedStatus!.id!, {"name": nameController.text.trim()});
    isLoading = false;
    update();
    
    if (response.statusCode == 200) {
      nameController.clear();
      selectedStatus = null;
      getTaskStatuses();
      return ResponseModel(true, response.body['message'] ?? "Status updated successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to update status");
    }
  }

  Future<ResponseModel> deleteTaskStatus(int id) async {
    isLoading = true;
    update();
    
    Response response = await taskRepo.deleteTaskStatus(id);
    isLoading = false;
    update();
    
    if (response.statusCode == 200) {
      getTaskStatuses();
      return ResponseModel(true, response.body['message'] ?? "Status removed successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to remove status");
    }
  }

  void setEditData(TaskStatusModel status) {
    selectedStatus = status;
    nameController.text = status.name ?? "";
    update();
  }

  void clearData() {
    selectedStatus = null;
    nameController.clear();
    update();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
