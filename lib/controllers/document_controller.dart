import 'package:get/get.dart';
import 'package:vlr/data/models/reports/document_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class DocumentController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  DocumentController({required this.reportsRepo});

  bool isLoading = false;
  List<DocumentModel> documentList = [];
  DocumentModel? selectedDocument;

  Future<void> getDocuments({Map<String, dynamic>? query}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getDocumentsList(query ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        documentList = [];
        final data = response.body['data']['data'] as List;
        for (var item in data) {
          documentList.add(DocumentModel.fromJson(item));
        }
      }
    } catch (e) {
      print("Error fetching documents: $e");
    }
    isLoading = false;
    update();
  }

  Future<void> getDocumentDetails(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getDocumentDetails(id);
      if (response.statusCode == 200 && response.body['status'] == "success") {
        selectedDocument = DocumentModel.fromJson(response.body['data']);
      }
    } catch (e) {
      print("Error fetching document details: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createDocumentRecord(dynamic body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createDocument(body);
      if (response.isOk && response.body['status'] == "success") {
        await getDocuments();
        return ResponseModel(true, response.body['message'] ?? "Document record created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create document record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateDocumentRecord(int id, dynamic body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateDocument(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getDocuments();
        return ResponseModel(true, response.body['message'] ?? "Document record updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update document record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteDocumentRecord(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteDocument(id);
      if (response.isOk && response.body['status'] == "success") {
        documentList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Document record deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete document record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
