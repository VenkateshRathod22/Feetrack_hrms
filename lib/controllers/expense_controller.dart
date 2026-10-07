import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlr/data/models/expense_category_model.dart';
import 'package:vlr/data/models/response/expense_model.dart';
import 'package:vlr/data/repositories/expense_repo.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';

class ExpenseController extends GetxController implements GetxService {
  final ExpenseRepo expenseRepo;

  ExpenseController({required this.expenseRepo});

  bool isLoading = false;
  ExpenseModel? selectedExpense;

  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ExpenseCategoryModel? selectedCategory;
  List<ExpenseCategoryModel> expenseCategoryList = [];

  File? pickedFile;
  final ImagePicker _picker = ImagePicker();

  void setExpense(ExpenseModel expense) {
    selectedExpense = expense;
    amountController.text = expense.amount ?? "";
    categoryController.text = expense.category ?? "";

    // Try to match the category if expense_category_id is present
    if (expense.expenseCategoryId != null) {
      selectedCategory = expenseCategoryList.firstWhereOrNull(
        (element) => element.id == expense.expenseCategoryId,
      );
    }
    
    if (expense.date != null) {
      try {
        DateTime parsedDate = DateTime.parse(expense.date!);
        dateController.text = DateFormatters().dMyDash.format(parsedDate);
      } catch (e) {
        dateController.text = expense.date!;
      }
    }
    
    descriptionController.text = expense.description ?? "";
    pickedFile = null;
    update();
  }

  Future<void> fetchExpenseCategories() async {
    Response response = await expenseRepo.getExpenseCategories();
    if (response.statusCode == 200) {
      expenseCategoryList = [];
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          expenseCategoryList.add(ExpenseCategoryModel.fromJson(v));
        });
      }

      // If editing, re-resolve selectedCategory
      if (selectedExpense != null && selectedExpense!.expenseCategoryId != null) {
        selectedCategory = expenseCategoryList.firstWhereOrNull(
          (element) => element.id == selectedExpense!.expenseCategoryId,
        );
      }
      update();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 50);
    if (image != null) {
      pickedFile = File(image.path);
      update();
    }
  }

  void showImagePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              "Select Image Source",
              style: Helper(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            sizedBoxHeight(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(context, Icons.camera_alt_rounded, "Camera", () {
                  Get.back();
                  pickImage(ImageSource.camera);
                }),
                _buildPickerOption(context, Icons.photo_library_rounded, "Gallery", () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                }),
              ],
            ),
            sizedBoxHeight(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 30.sp),
          ),
          sizedBoxHeight(height: 8),
          CustomText(label, style: Helper(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  List<ExpenseModel> expenseList = [];
  List<ExpenseModel> teamExpenseList = [];

  Future<void> fetchExpenses() async {
    isLoading = true;
    update();

    try {
      Response response = await expenseRepo.getExpenses();

      if (response.statusCode == 200) {
        expenseList = [];
        response.body['data'].forEach((v) {
          expenseList.add(ExpenseModel.fromJson(v));
        });
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchTeamExpenses(String status) async {
    isLoading = true;
    update();

    try {
      Response response = await expenseRepo.getTeamExpenses(status);

      if (response.statusCode == 200) {
        teamExpenseList = [];
        if (response.body['data']['data'] != null) {
          response.body['data']['data'].forEach((v) {
            teamExpenseList.add(ExpenseModel.fromJson(v));
          });
        }
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> submitExpense() async {
    if (dateController.text.isEmpty) {
      showToast(message: "Please select a date", toastType: ToastType.warning);
      return;
    }
    
    isLoading = true;
    update();

    try {
      String date = DateFormatters().yMD.format(DateFormatters().dMyDash.parse(dateController.text));

      Map<String, dynamic> body = {
        "amount": amountController.text,
        "category": selectedCategory?.name ?? categoryController.text,
        "expense_category_id": selectedCategory?.id,
        "date": date,
        "description": descriptionController.text,
      };

      if (pickedFile != null) {
        body["upload_file"] = await MultipartFile(pickedFile, filename: pickedFile!.path.split('/').last);
      }

      Response response = await expenseRepo.applyExpense(FormData(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToast(message: response.body['message'] ?? "Expense submitted successfully", toastType: ToastType.success);
        clearFields();
        Get.back();
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      log("ERROR AT submitExpense: $e");
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateExpense() async {
    if (selectedExpense == null) return;
    if (dateController.text.isEmpty) {
      showToast(message: "Please select a date", toastType: ToastType.warning);
      return;
    }

    isLoading = true;
    update();

    try {
      String date = DateFormatters().yMD.format(DateFormatters().dMyDash.parse(dateController.text));

      Map<String, dynamic> body = {
        "_method": "PUT",
        "amount": amountController.text,
        "category": selectedCategory?.name ?? categoryController.text,
        "expense_category_id": selectedCategory?.id,
        "date": date,
        "description": descriptionController.text,
      };

      if (pickedFile != null) {
        body["upload_file"] = await MultipartFile(pickedFile, filename: pickedFile!.path.split('/').last);
      }

      Response response = await expenseRepo.updateExpense(selectedExpense!.id!, FormData(body));

      if (response.statusCode == 200) {
        showToast(message: response.body['message'] ?? "Expense updated successfully", toastType: ToastType.success);
        clearFields();
        Get.back();
        fetchExpenses();
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      log("ERROR AT updateExpense: $e");
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateExpenseStatus(int expenseId, String status, {String? currentTabStatus}) async {
    isLoading = true;
    update();

    try {
      Response response = await expenseRepo.updateExpenseStatus(expenseId, status);

      if (response.statusCode == 200) {
        showToast(message: response.body['message'] ?? "Expense status updated", toastType: ToastType.success);
        if (currentTabStatus != null) {
          fetchTeamExpenses(currentTabStatus);
        }
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearFields() {
    selectedExpense = null;
    selectedCategory = null;
    amountController.clear();
    categoryController.clear();
    dateController.clear();
    descriptionController.clear();
    pickedFile = null;
    update();
  }

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
