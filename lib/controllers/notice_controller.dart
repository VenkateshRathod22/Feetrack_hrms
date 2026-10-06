import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/notice_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/notice_repo.dart';

class NoticeController extends GetxController implements GetxService {
  final NoticeRepo noticeRepo;

  NoticeController({required this.noticeRepo});

  bool isLoading = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController actionLinkController = TextEditingController();
  final TextEditingController actionTextController = TextEditingController();

  String selectedType = 'global';
  List<int> selectedUserIds = [];
  List<int> selectedBranchIds = [];
  List<int> selectedDepartmentIds = [];

  void clearControllers() {
    titleController.clear();
    contentController.clear();
    startDateController.clear();
    endDateController.clear();
    actionLinkController.clear();
    actionTextController.clear();
    selectedType = 'global';
    selectedUserIds = [];
    selectedBranchIds = [];
    selectedDepartmentIds = [];
  }

  void setEditData(NoticeModel notice) {
    titleController.text = notice.title ?? "";
    contentController.text = notice.content ?? "";
    startDateController.text = notice.startDate?.toString().split(' ')[0] ?? "";
    endDateController.text = notice.endDate?.toString().split(' ')[0] ?? "";
    actionLinkController.text = notice.actionLink ?? "";
    actionTextController.text = notice.actionText ?? "";
    selectedType = notice.type ?? "global";
    // IDs might need careful mapping depending on how they come from API
  }

  Future<ResponseModel> createNotice() async {
    isLoading = true;
    update();
    try {
      Map<String, dynamic> body = {
        "title": titleController.text,
        "content": contentController.text,
        "type": selectedType,
        "start_date": startDateController.text,
        "end_date": endDateController.text,
        "action_link": actionLinkController.text,
        "action_text": actionTextController.text,
      };
      if (selectedUserIds.isNotEmpty) body["user_ids"] = selectedUserIds;
      if (selectedBranchIds.isNotEmpty) body["branch_ids"] = selectedBranchIds;
      if (selectedDepartmentIds.isNotEmpty) {
        body["department_ids"] = selectedDepartmentIds;
      }

      Response response = await noticeRepo.createNotice(body);
      if (response.body != null &&
          (response.body['status'] == "success" ||
              response.statusCode == 200)) {
        fetchNoticeBoard();
        return ResponseModel(true, "Notice created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Error");
      }
    } catch (e) {
      return ResponseModel(false, e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateNotice(int id) async {
    isLoading = true;
    update();
    try {
      Map<String, dynamic> body = {
        "title": titleController.text,
        "content": contentController.text,
        "type": selectedType,
        "start_date": startDateController.text,
        "end_date": endDateController.text,
        "action_link": actionLinkController.text,
        "action_text": actionTextController.text,
      };

      Response response = await noticeRepo.updateNotice(id, body);
      if (response.body != null && response.body['status'] == "success") {
        fetchNoticeBoard();
        return ResponseModel(true, "Notice updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Error");
      }
    } catch (e) {
      return ResponseModel(false, e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteNotice(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await noticeRepo.deleteNotice(id);
      if (response.body != null && response.body['status'] == "success") {
        noticeModelList.removeWhere((element) => element.id == id);
        return ResponseModel(true, "Notice deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Error");
      }
    } catch (e) {
      return ResponseModel(false, e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  List<NoticeModel> noticeModelList = [];
  Future<ResponseModel> fetchNoticeBoard() async {
    // log('----------- fetchNoticeBoard Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await noticeRepo.fetchNoticeBoard();

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchNoticeBoard successful",
        );

        final List<dynamic> data = response.body['data'] as List<dynamic>;

        noticeModelList = data
            .map((e) => NoticeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while fetchNoticeBoard user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      // log('ERROR AT fetchNoticeBoard(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchNoticeBoard user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  NoticeModel? noticeModel;
  Future<ResponseModel> fetchNoticeBoardById({required int id}) async {
    // log('----------- fetchNoticeBoardById Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await noticeRepo.fetchNoticeBoardById(id: id);

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchNoticeBoardById successful",
        );

        noticeModel = NoticeModel.fromJson(response.body['data']);
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while fetchNoticeBoardById user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      // log('ERROR AT fetchNoticeBoardById(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchNoticeBoardById user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
