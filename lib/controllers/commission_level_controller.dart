import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/commission_level_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/commission_level_repo.dart';

class CommissionLevelController extends GetxController implements GetxService {
  final CommissionLevelRepo commissionLevelRepo;

  CommissionLevelController({required this.commissionLevelRepo});

  bool isLoading = false;
  List<CommissionLevelModel> commissionLevelList = [];

  final TextEditingController levelNameController = TextEditingController();
  final TextEditingController levelOrderController = TextEditingController();
  final TextEditingController commissionPercentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<ResponseModel> getCommissionLevelList({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null) query['search'] = search;

      Response response = await commissionLevelRepo.getCommissionLevels(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        commissionLevelList = data.map((e) => CommissionLevelModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Commission levels fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch commission levels");
      }
    } catch (e) {
      log("ERROR AT getCommissionLevelList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> addCommissionLevel() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "level_name": levelNameController.text,
        "level_order": int.tryParse(levelOrderController.text),
        "commission_percent": commissionPercentController.text,
        "description": descriptionController.text,
      };

      Response response = await commissionLevelRepo.addCommissionLevel(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getCommissionLevelList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Commission Level added successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to add commission level");
      }
    } catch (e) {
      log("ERROR AT addCommissionLevel: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateCommissionLevel(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "level_name": levelNameController.text,
        "level_order": int.tryParse(levelOrderController.text),
        "commission_percent": commissionPercentController.text,
        "description": descriptionController.text,
      };

      Response response = await commissionLevelRepo.updateCommissionLevel(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getCommissionLevelList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Commission Level updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update commission level");
      }
    } catch (e) {
      log("ERROR AT updateCommissionLevel: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteCommissionLevel(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await commissionLevelRepo.deleteCommissionLevel(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        commissionLevelList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Commission Level removed successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to remove commission level");
      }
    } catch (e) {
      log("ERROR AT deleteCommissionLevel: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    levelNameController.clear();
    levelOrderController.clear();
    commissionPercentController.clear();
    descriptionController.clear();
    update();
  }

  void setEditData(CommissionLevelModel level) {
    levelNameController.text = level.levelName ?? "";
    levelOrderController.text = level.levelOrder?.toString() ?? "";
    commissionPercentController.text = level.commissionPercent ?? "";
    descriptionController.text = level.description ?? "";
    update();
  }

  @override
  void onClose() {
    levelNameController.dispose();
    levelOrderController.dispose();
    commissionPercentController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
