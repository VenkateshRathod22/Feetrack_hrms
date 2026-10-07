import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class TaskRepo {
  final ApiClient apiClient;

  TaskRepo({required this.apiClient});

  Future<Response> getTaskStatuses({String? search}) async {
    return await apiClient.getData(
      AppConstants.taskStatuses, 
      "getTaskStatuses", 
      query: search != null ? {"search": search} : null
    );
  }

  Future<Response> addTaskStatus(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.taskStatuses, "addTaskStatus", body);
  }

  Future<Response> updateTaskStatus(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.taskStatuses}/$id", "updateTaskStatus", body);
  }

  Future<Response> deleteTaskStatus(int id) async {
    return await apiClient.deleteData("${AppConstants.taskStatuses}/$id", "deleteTaskStatus");
  }

  // Task Management
  Future<Response> getEmployeesListing() async {
    return await apiClient.getData(AppConstants.assignableUsers, "getEmployeesListing");
  }

  Future<Response> getTasks() async {
    return await apiClient.getData(AppConstants.tasks, "getTasks");
  }

  Future<Response> createTask(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.tasks, "createTask", body);
  }

  Future<Response> updateTask(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.tasks}/$id", "updateTask", body);
  }

  Future<Response> deleteTask(int id) async {
    return await apiClient.deleteData("${AppConstants.tasks}/$id", "deleteTask");
  }

  Future<Response> getTaskRemarks(int id) async {
    return await apiClient.getData("${AppConstants.tasks}/$id/remarks", "getTaskRemarks");
  }

  Future<Response> addTaskRemark(int id, Map<String, dynamic> body) async {
    return await apiClient.postData("${AppConstants.tasks}/$id/remarks", "addTaskRemark", body);
  }

  Future<Response> updateTaskProgressStatus(int id, Map<String, dynamic> body) async {
    return await apiClient.postData("${AppConstants.tasks}/$id/status", "updateTaskProgressStatus", FormData(body));
  }
}
