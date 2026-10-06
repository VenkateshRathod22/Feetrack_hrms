import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/task_model.dart';
import 'package:vlr/data/models/response/task_status_model.dart';
import 'package:vlr/data/models/user_model.dart';
import 'package:vlr/data/repositories/task_repo.dart';
import 'package:vlr/main.dart';
import 'package:vlr/services/constants.dart';

class TaskController extends GetxController implements GetxService {
  final TaskRepo taskRepo;

  TaskController({required this.taskRepo});

  bool isLoading = false;
  List<TaskModel> taskList = [];
  TaskModel? selectedTask;

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriController = TextEditingController();

  UserModel? assignTo;
  TaskStatusModel? taskStatus;

  List<TaskStatusModel> taskStatusList = [];

  List<UserModel> assignToList = [];

  List<TaskRemarkModel> taskRemarks = [];
  bool isRemarkLoading = false;

  void setTask(TaskModel task) {
    selectedTask = task;
    titleController.text = task.title ?? "";
    descriController.text = task.description ?? "";
    
    // Set due date (ensure format matches dd-mm-yyyy if possible)
    if (task.dueDate != null) {
      try {
        List<String> parts = task.dueDate!.split("-");
        if (parts.length == 3 && parts[0].length == 4) {
          // yyyy-mm-dd to dd-mm-yyyy
          dateController.text = "${parts[2]}-${parts[1]}-${parts[0]}";
        } else {
          dateController.text = task.dueDate!;
        }
      } catch (e) {
        dateController.text = task.dueDate!;
      }
    }

    // Resolve assignee from the list
    if (task.employeeId != null) {
      assignTo = assignToList.firstWhereOrNull((element) => element.id == task.employeeId);
    }

    // Resolve status from the list (try matching name or slug)
    if (task.status != null) {
      taskStatus = taskStatusList.firstWhereOrNull(
        (element) => element.name?.toLowerCase() == task.status!.toLowerCase() || 
                     element.slug?.toLowerCase() == task.status!.toLowerCase(),
      );
    }
    
    update();
  }

  Future<void> fetchTaskStatuses() async {
    Response response = await taskRepo.getTaskStatuses();
    if (response.statusCode == 200) {
      taskStatusList = [];
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          taskStatusList.add(TaskStatusModel.fromJson(v));
        });
      }
      
      // If editing, resolve taskStatus from the fetched list
      if (selectedTask != null && selectedTask!.status != null) {
        taskStatus = taskStatusList.firstWhereOrNull(
          (element) => element.name?.toLowerCase() == selectedTask!.status!.toLowerCase(),
        );
      }
      update();
    }
  }

  Future<void> fetchEmployees() async {
    Response response = await taskRepo.getEmployeesListing();
    if (response.statusCode == 200) {
      assignToList = [];
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          assignToList.add(UserModel.fromJson(v));
        });
      }
      
      // Re-resolve assignee if we were waiting for the list
      if (selectedTask != null && selectedTask!.employeeId != null && assignTo == null) {
        assignTo = assignToList.firstWhereOrNull((element) => element.id == selectedTask!.employeeId);
      }
      
      update();
    }
  }

  Future<void> getTasks() async {
    isLoading = true;
    update();

    Response response = await taskRepo.getTasks();
    if (response.statusCode == 200) {
      taskList = [];
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          taskList.add(TaskModel.fromJson(v));
        });
      }
    } else {
      showToast(message: response.statusText ?? "Failed to fetch tasks", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> addTask() async {
    if (titleController.text.isEmpty || assignTo == null || dateController.text.isEmpty) {
      showToast(message: "Please fill all required fields", toastType: ToastType.warning);
      return;
    }

    isLoading = true;
    update();

    String dueDate = _getFormattedDate();

    Map<String, dynamic> body = {
      "employee_id": assignTo?.id ?? "",
      "title": titleController.text.trim(),
      "description": descriController.text.trim(),
      "due_date": dueDate,
      "status": taskStatus?.slug ?? "pending",
    };

    Response response = await taskRepo.createTask(body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      showToast(message: response.body['message'] ?? "Task assigned successfully", toastType: ToastType.success);
      clearControllers();
      getTasks();
      pop(navigatorKey.currentContext!);
    } else {
      showToast(message: response.statusText ?? "Failed to assign task", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> updateTask() async {
    if (selectedTask == null) return;
    if (titleController.text.isEmpty || dateController.text.isEmpty) {
      showToast(message: "Please fill all required fields", toastType: ToastType.warning);
      return;
    }

    isLoading = true;
    update();

    String dueDate = _getFormattedDate();

    Map<String, dynamic> body = {
      "title": titleController.text.trim(),
      "description": descriController.text.trim(),
      "due_date": dueDate,
      "status": taskStatus?.slug ?? "pending",
    };

    Response response = await taskRepo.updateTask(selectedTask!.id!, body);
    if (response.statusCode == 200) {
      showToast(message: response.body['message'] ?? "Task updated successfully", toastType: ToastType.success);
      clearControllers();
      getTasks();
      pop(navigatorKey.currentContext!);
    } else {
      showToast(message: response.statusText ?? "Failed to update task", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> deleteTask(int taskId) async {
    isLoading = true;
    update();

    Response response = await taskRepo.deleteTask(taskId);
    if (response.statusCode == 200) {
      showToast(message: response.body['message'] ?? "Task deleted successfully", toastType: ToastType.success);
      getTasks();
    } else {
      showToast(message: response.statusText ?? "Failed to delete task", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> getTaskRemarks(int taskId) async {
    isRemarkLoading = true;
    taskRemarks = [];
    update();

    Response response = await taskRepo.getTaskRemarks(taskId);
    if (response.statusCode == 200) {
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          taskRemarks.add(TaskRemarkModel.fromJson(v));
        });
      }
    }
    isRemarkLoading = false;
    update();
  }

  Future<void> addTaskRemark(int taskId, String remark) async {
    if (remark.isEmpty) return;

    isLoading = true;
    update();

    Map<String, dynamic> body = {"remark": remark};
    Response response = await taskRepo.addTaskRemark(taskId, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showToast(message: response.body['message'] ?? "Remark added", toastType: ToastType.success);
      getTaskRemarks(taskId);
    } else {
      showToast(message: response.statusText ?? "Failed to add remark", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> updateTaskProgressStatus(int taskId, String status) async {
    isLoading = true;
    update();

    Map<String, dynamic> body = {"status": status};
    Response response = await taskRepo.updateTaskProgressStatus(taskId, body);

    if (response.statusCode == 200) {
      showToast(message: response.body['message'] ?? "Task status updated", toastType: ToastType.success);
      getTasks();
    } else {
      showToast(message: response.statusText ?? "Failed to update status", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  String _getFormattedDate() {
    String dueDate = "";
    try {
      List<String> parts = dateController.text.split("-");
      if (parts.length == 3) {
        dueDate = "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    } catch (e) {
      dueDate = dateController.text;
    }
    return dueDate;
  }

  void clearControllers() {
    selectedTask = null;
    titleController.clear();
    dateController.clear();
    descriController.clear();
    assignTo = null;
    taskStatus = null;
    update();
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    descriController.dispose();
    super.dispose();
  }
}
