import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/pipeline_stage_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/pipeline_stage_repo.dart';

class PipelineStageController extends GetxController implements GetxService {
  final PipelineStageRepo pipelineStageRepo;

  PipelineStageController({required this.pipelineStageRepo});

  bool isLoading = false;
  List<PipelineStageModel> pipelineStageList = [];

  final TextEditingController nameController = TextEditingController();
  String? selectedDepartmentId;
  bool countsTowardsTarget = false;

  Future<ResponseModel> getPipelineStageList({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null) query['search'] = search;

      Response response = await pipelineStageRepo.getPipelineStages(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        pipelineStageList = data.map((e) => PipelineStageModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Pipeline stages fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch pipeline stages");
      }
    } catch (e) {
      log("ERROR AT getPipelineStageList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> addPipelineStage() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "department_id": selectedDepartmentId,
        "counts_towards_target": countsTowardsTarget,
      };

      Response response = await pipelineStageRepo.addPipelineStage(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getPipelineStageList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Pipeline stage added successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to add pipeline stage");
      }
    } catch (e) {
      log("ERROR AT addPipelineStage: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updatePipelineStage(String id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "department_id": selectedDepartmentId,
        "counts_towards_target": countsTowardsTarget,
      };

      Response response = await pipelineStageRepo.updatePipelineStage(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getPipelineStageList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Pipeline stage updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update pipeline stage");
      }
    } catch (e) {
      log("ERROR AT updatePipelineStage: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deletePipelineStage(String id) async {
    isLoading = true;
    update();

    try {
      Response response = await pipelineStageRepo.deletePipelineStage(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        pipelineStageList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Pipeline stage deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete pipeline stage");
      }
    } catch (e) {
      log("ERROR AT deletePipelineStage: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    nameController.clear();
    selectedDepartmentId = null;
    countsTowardsTarget = false;
    update();
  }

  void setEditData(PipelineStageModel stage) {
    nameController.text = stage.name ?? "";
    selectedDepartmentId = stage.departmentId?.toString();
    countsTowardsTarget = stage.countsTowardsTarget ?? false;
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
