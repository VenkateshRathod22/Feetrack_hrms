import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class NoticeRepo {
  final ApiClient apiClient;

  NoticeRepo({required this.apiClient});

  Future<Response> fetchNoticeBoard() async => await apiClient.getData(
        AppConstants.getNoticeBoard,
        "fetchNoticeBoard",
      );
  Future<Response> fetchNoticeBoardById({required int id}) async =>
      await apiClient.getData(
        "${AppConstants.getNoticeBoardById}/$id",
        "fetchNoticeBoardById",
      );

  Future<Response> createNotice(Map<String, dynamic> body) async =>
      await apiClient.postData(
        AppConstants.getNoticeBoard,
        "createNotice",
        body,
      );

  Future<Response> updateNotice(int id, Map<String, dynamic> body) async =>
      await apiClient.putData(
        "${AppConstants.getNoticeBoard}/$id",
        "updateNotice",
        body,
      );

  Future<Response> deleteNotice(int id) async => await apiClient.deleteData(
        "${AppConstants.getNoticeBoard}/$id",
        "deleteNotice",
      );
}
