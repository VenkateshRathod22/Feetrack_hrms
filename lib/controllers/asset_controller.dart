import 'package:get/get.dart';
import 'package:vlr/data/models/asset_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class AssetController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  AssetController({required this.reportsRepo});

  bool isLoading = false;
  List<AssetModel> assetList = [];
  AssetSummary? summary;
  List<AssetCategoryBreakdown> categoryBreakdown = [];
  String? generatedAssetCode;

  Future<void> getAssets({Map<String, dynamic>? query}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getAssetsList(query ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        assetList = [];
        final data = response.body['data']['data'] as List;
        for (var item in data) {
          assetList.add(AssetModel.fromJson(item));
        }
        
        if (response.body['summary'] != null) {
          summary = AssetSummary.fromJson(response.body['summary']);
        }
        
        if (response.body['category_breakdown'] != null) {
          categoryBreakdown = (response.body['category_breakdown'] as List)
              .map((e) => AssetCategoryBreakdown.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching assets: $e");
    }
    isLoading = false;
    update();
  }

  Future<String?> generateCode() async {
    try {
      Response response = await reportsRepo.generateAssetCode();
      if (response.statusCode == 200 && response.body['status'] == "success") {
        generatedAssetCode = response.body['asset_code'];
        return generatedAssetCode;
      }
    } catch (e) {
      print("Error generating asset code: $e");
    }
    return null;
  }

  Future<ResponseModel> createAsset(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.addAsset(body);
      if (response.isOk && response.body['status'] == "success") {
        await getAssets();
        return ResponseModel(true, response.body['message'] ?? "Asset added successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to add asset");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateAsset(int id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateAsset(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getAssets();
        return ResponseModel(true, response.body['message'] ?? "Asset updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update asset");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteAsset(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteAsset(id);
      if (response.isOk && response.body['status'] == "success") {
        assetList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Asset deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete asset");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
