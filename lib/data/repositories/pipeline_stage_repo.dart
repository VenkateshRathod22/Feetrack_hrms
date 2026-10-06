import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class PipelineStageRepo {
  final ApiClient apiClient;

  PipelineStageRepo({required this.apiClient});

  Future<Response> getPipelineStages(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.pipelineStages, "getPipelineStages", query: query);
  }

  Future<Response> addPipelineStage(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.pipelineStages, "addPipelineStage", body);
  }

  Future<Response> updatePipelineStage(String id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.pipelineStages}/$id", "updatePipelineStage", body);
  }

  Future<Response> deletePipelineStage(String id) async {
    return await apiClient.deleteData("${AppConstants.pipelineStages}/$id", "deletePipelineStage");
  }
}
