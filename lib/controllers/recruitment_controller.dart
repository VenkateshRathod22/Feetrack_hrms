import 'dart:developer';

import 'package:get/get.dart';
import 'package:vlr/data/models/reports/recruitment_report_model.dart';
import 'package:vlr/data/models/response/applied_job_model.dart';
import 'package:vlr/data/models/response/job_plan_model.dart';
import 'package:vlr/data/models/response/job_post_history_model.dart';
import 'package:vlr/data/models/response/job_template_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class RecruitmentController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  RecruitmentController({required this.reportsRepo});

  bool isLoading = false;
  List<RecruitmentModel> recruitmentList = [];

  bool isAppliedJobsLoading = false;
  List<AppliedJobModel> appliedJobList = [];

  bool isJobPlansLoading = false;
  List<JobPlanModel> jobPlanList = [];

  bool isJobTemplatesLoading = false;
  List<JobTemplateModel> jobTemplateList = [];

  bool isJobPostsHistoryLoading = false;
  List<JobPostHistoryModel> jobPostsHistoryList = [];

  Future<void> getAppliedJobs({Map<String, dynamic>? query}) async {
    isAppliedJobsLoading = true;
    update();
    try {
      Response response = await reportsRepo.getAppliedJobsList(query ?? {});
      if (response.statusCode == 200 &&
          (response.body['success'] == true || response.body['status'] == "success")) {
        appliedJobList = [];
        dynamic rawData = response.body['data'];
        List itemsList = [];
        if (rawData is Map && rawData['data'] is List) {
          itemsList = rawData['data'];
        } else if (rawData is List) {
          itemsList = rawData;
        }
        for (var item in itemsList) {
          appliedJobList.add(AppliedJobModel.fromJson(item));
        }
      }
    } catch (e) {
      log("Error fetching applied jobs: $e");
    }
    isAppliedJobsLoading = false;
    update();
  }

  Future<ResponseModel> updateAppliedJobStatus(int id, String status) async {
    isAppliedJobsLoading = true;
    update();
    try {
      Map<String, dynamic> body = {
        "status": status,
      };
      Response response = await reportsRepo.updateAppliedJobStatus(id, body);
      if (response.isOk &&
          (response.body['success'] == true || response.body['status'] == "success")) {
        await getAppliedJobs();
        return ResponseModel(true, response.body['message'] ?? "Job status updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update job status");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isAppliedJobsLoading = false;
      update();
    }
  }

  Future<void> getRecruitments({Map<String, dynamic>? query}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getRecruitmentsList(query ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        recruitmentList = [];
        final data = response.body['data']['data'] as List;
        for (var item in data) {
          recruitmentList.add(RecruitmentModel.fromJson(item));
        }
      }
    } catch (e) {
      log("Error fetching recruitments: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createRecruitmentRecord(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createRecruitment(body);
      if (response.isOk && response.body['status'] == "success") {
        await getRecruitments();
        return ResponseModel(true, response.body['message'] ?? "Recruitment record created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create recruitment record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateRecruitmentRecord(int id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateRecruitment(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getRecruitments();
        return ResponseModel(true, response.body['message'] ?? "Recruitment record updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update recruitment record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteRecruitmentRecord(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteRecruitment(id);
      if (response.isOk && response.body['status'] == "success") {
        recruitmentList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Recruitment record deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete recruitment record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> createJobPost(dynamic body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createJobPost(body);
      if (response.isOk &&
          (response.body['success'] == true || response.body['status'] == "success")) {
        return ResponseModel(true, response.body['message'] ?? "Job Post created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create job post");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getJobPlans() async {
    isJobPlansLoading = true;
    update();
    try {
      Response response = await reportsRepo.getJobPlans();
      if (response.statusCode == 200 &&
          (response.body['success'] == true || response.body['status'] == "success")) {
        jobPlanList = [];
        dynamic rawData = response.body['data'];
        List itemsList = [];
        if (rawData is List) {
          itemsList = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          itemsList = rawData['data'];
        }
        for (var item in itemsList) {
          jobPlanList.add(JobPlanModel.fromJson(item));
        }
      }
    } catch (e) {
      log("Error fetching job plans: $e");
    } finally {
      isJobPlansLoading = false;
      update();
    }
  }

  Future<void> getJobTemplates() async {
    isJobTemplatesLoading = true;
    update();
    try {
      Response response = await reportsRepo.getJobTemplates();
      if (response.statusCode == 200 &&
          (response.body['success'] == true || response.body['status'] == "success")) {
        jobTemplateList = [];
        dynamic rawData = response.body['data'];
        List itemsList = [];
        if (rawData is List) {
          itemsList = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          itemsList = rawData['data'];
        }
        for (var item in itemsList) {
          jobTemplateList.add(JobTemplateModel.fromJson(item));
        }
      }
    } catch (e) {
      log("Error fetching job templates: $e");
    } finally {
      isJobTemplatesLoading = false;
      update();
    }
  }

  Future<void> getJobPostsHistory() async {
    isJobPostsHistoryLoading = true;
    update();
    try {
      Response response = await reportsRepo.getJobPostsHistory();
      if (response.statusCode == 200 &&
          (response.body['success'] == true || response.body['status'] == "success")) {
        jobPostsHistoryList = [];
        dynamic rawData = response.body['data'];
        List itemsList = [];
        if (rawData is Map && rawData['data'] is List) {
          itemsList = rawData['data'];
        } else if (rawData is List) {
          itemsList = rawData;
        }
        for (var item in itemsList) {
          jobPostsHistoryList.add(JobPostHistoryModel.fromJson(item));
        }
      }
    } catch (e) {
      log("Error fetching job posts history: $e");
    } finally {
      isJobPostsHistoryLoading = false;
      update();
    }
  }

  Future<JobTemplateModel?> getJobTemplateDetails(int id) async {
    try {
      Response response = await reportsRepo.getJobTemplateDetails(id);
      if (response.isOk &&
          (response.body['success'] == true || response.body['status'] == "success")) {
        dynamic rawData = response.body['data'];
        if (rawData is Map<String, dynamic>) {
          return JobTemplateModel.fromJson(rawData);
        }
      }
    } catch (e) {
      log("Error fetching job template details: $e");
    }
    return null;
  }
}
