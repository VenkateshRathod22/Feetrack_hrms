
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vlr/data/models/response/company_document_model.dart';
import 'package:vlr/data/models/response/process_note_model.dart';
import 'package:vlr/data/repositories/about_company_repo.dart';

class AboutCompanyController extends GetxController implements GetxService {
  final AboutCompanyRepo aboutCompanyRepo;
  AboutCompanyController({required this.aboutCompanyRepo});

  bool isLoading = false;
  List<CompanyDocumentModel> documents = [];
  List<ProcessNoteModel> processNotes = [];

  final TextEditingController searchController = TextEditingController();

  Future<void> getCompanyDocuments({String? search}) async {
    isLoading = true;
    update();

    Response response = await aboutCompanyRepo.getCompanyDocuments(search: search);
    if (response.statusCode == 200 && response.body['status'] == "success") {
      documents = [];
      final List data = response.body['data'];
      for (var item in data) {
        documents.add(CompanyDocumentModel.fromJson(item));
      }
    }
    isLoading = false;
    update();
  }

  Future<void> getProcessNotes({String? search}) async {
    isLoading = true;
    update();

    Response response = await aboutCompanyRepo.getProcessNotes(search: search);
    if (response.statusCode == 200 && response.body['status'] == "success") {
      processNotes = [];
      final List data = response.body['data'];
      for (var item in data) {
        processNotes.add(ProcessNoteModel.fromJson(item));
      }
    }
    isLoading = false;
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
