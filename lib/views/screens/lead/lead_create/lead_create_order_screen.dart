import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/controllers/product_controller.dart';
import 'package:vlr/data/models/product_model.dart';
import 'package:vlr/data/models/response/lead_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class LeadCreateOrderScreen extends StatefulWidget {
  const LeadCreateOrderScreen({super.key});

  @override
  State<LeadCreateOrderScreen> createState() => _LeadCreateOrderScreenState();
}

class _LeadCreateOrderScreenState extends State<LeadCreateOrderScreen> {
  LeadModel? selectedLead;
  ProductModel? selectedProduct;

  final TextEditingController amountController = TextEditingController(text: "0");
  final TextEditingController gstPercentController = TextEditingController(text: "0");
  final TextEditingController quantityController = TextEditingController(text: "1");
  final TextEditingController discountController = TextEditingController(text: "0");
  final TextEditingController paidNowController = TextEditingController(text: "0");

  String selectedGstOption = "Not Include (0%)";
  final List<String> gstOptions = ["Not Include (0%)", "GST 5%", "GST 12%", "GST 18%", "GST 28%"];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeadController>().getWonLeads();
      Get.find<ProductController>().getProducts();
    });

    void onFieldChanged() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _calculateTotals();
      });
    }

    amountController.addListener(onFieldChanged);
    quantityController.addListener(onFieldChanged);
    discountController.addListener(onFieldChanged);
    paidNowController.addListener(onFieldChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    amountController.dispose();
    gstPercentController.dispose();
    quantityController.dispose();
    discountController.dispose();
    paidNowController.dispose();
    super.dispose();
  }

  void _calculateTotals() async {
    if (selectedProduct == null || !mounted) return;
    
    double price = double.tryParse(amountController.text) ?? 0;
    int qty = int.tryParse(quantityController.text) ?? 1;
    double disc = double.tryParse(discountController.text) ?? 0;
    double paid = double.tryParse(paidNowController.text) ?? 0;

    debugPrint("Triggering calculation: product=${selectedProduct!.id}, amount=$price, qty=$qty, discount=$disc, paid=$paid");
    
    final leadCtrl = Get.find<LeadController>();
    await leadCtrl.calculateLeadOrder(
      productId: selectedProduct!.id!,
      amount: price,
      quantity: qty,
      discount: disc,
      paidAmount: paid,
    );

    if (leadCtrl.calculationData != null && mounted) {
      final rate = leadCtrl.calculationData!.gstRate?.toString() ?? "0";
      
      // Use post-frame callback to avoid build-phase collisions
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        
        if (gstPercentController.text != rate) {
          gstPercentController.text = rate;
        }
        
        setState(() {
          if (rate == "0") {
            selectedGstOption = "Not Include (0%)";
          } else {
            String match = "GST $rate%";
            if (gstOptions.contains(match)) {
              selectedGstOption = match;
            } else {
              selectedGstOption = gstOptions.firstWhere((opt) => opt.contains(rate), orElse: () => gstOptions[0]);
            }
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration:  BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: white, size: 14.sp),
            ),
            sizedBoxWidth(width: 10),
            CustomText(
              "Create New Lead Order",
              style: Helper(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded, color: greyDart2),
          ),
        ],
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<LeadController>(
        init: Get.find<LeadController>(),
        builder: (leadCtrl) {
          debugPrint("LeadCreateOrderScreen Builder: WonLeads count = ${leadCtrl.wonLeadsList.length}");
          return GetBuilder<ProductController>(
            init: Get.find<ProductController>(),
            builder: (productCtrl) {
          return Column(
            children: [
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionCard(
                        title: "ORDER DETAILS",
                        icon: Icons.shopping_bag_outlined,
                        children: [
                          CustomDropDownList<LeadModel>(
                            heading: "SELECT LEAD (WON STATUS)",
                            isRequired: true,
                            items: leadCtrl.wonLeadsList,
                            value: selectedLead,
                            hintText: leadCtrl.isLoading ? "Loading Leads..." : "-- Choose Lead --",
                            onChanged: (val) {
                              setState(() => selectedLead = val);
                            },
                          ),
                          sizedBoxHeight(height: 20),
                          CustomDropDownList<ProductModel>(
                            heading: "SELECT PRODUCT",
                            isRequired: true,
                            items: productCtrl.productList,
                            value: selectedProduct,
                            hintText: productCtrl.isLoading ? "Loading Products..." : "-- Choose Product --",
                            onChanged: (val) {
                              if (val != null) {
                                debugPrint("Product selected: ${val.name}");
                                // Update controllers first
                                amountController.text = val.amount ?? "0";
                                gstPercentController.text = val.gstPercent?.toString() ?? "0";
                                
                                String newGstOption = "Not Include (0%)";
                                if (val.gstType == "include") {
                                  newGstOption = "GST ${val.gstPercent}%";
                                }

                                setState(() {
                                  selectedProduct = val;
                                  selectedGstOption = newGstOption;
                                });

                                // Small delay to ensure state is settled before hitting calculation
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  _calculateTotals();
                                });
                              }
                            },
                          ),
                          sizedBoxHeight(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextFieldWithHeading(
                                  heading: "PRODUCT AMOUNT",
                                  isRequired: true,
                                  hindText: "0",
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  preFixWidget: Padding(
                                    padding: EdgeInsets.all(12.r),
                                    child: CustomText("₹", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: primaryColor)),
                                  ),
                                ),
                              ),
                              sizedBoxWidth(width: 16),
                              Expanded(
                                child: AppTextFieldWithHeading(
                                  heading: "QUANTITY",
                                  isRequired: true,
                                  hindText: "1",
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      sizedBoxHeight(height: 20),
                      _buildSectionCard(
                        title: "TAX & PAYMENTS",
                        icon: Icons.payments_outlined,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildGstOptionDropdown(leadCtrl)),
                              sizedBoxWidth(width: 16),
                              Expanded(
                                child: AppTextFieldWithHeading(
                                  heading: "GST PERCENTAGE (%)",
                                  hindText: "0.0",
                                  controller: gstPercentController,
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  suffix: Padding(
                                    padding: EdgeInsets.all(12.r),
                                    child: CustomText("%", style: TextStyle(color: grey, fontSize: 14.sp)),
                                  ),
                                  preFixWidget: Icon(Icons.lock_outline, size: 16.sp, color: grey),
                                ),
                              ),
                            ],
                          ),
                          sizedBoxHeight(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextFieldWithHeading(
                                  heading: "DISCOUNT",
                                  hindText: "0",
                                  controller: discountController,
                                  keyboardType: TextInputType.number,
                                  preFixWidget: Padding(
                                    padding: EdgeInsets.all(12.r),
                                    child: CustomText("₹", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.red)),
                                  ),
                                ),
                              ),
                              sizedBoxWidth(width: 16),
                              Expanded(
                                child: AppTextFieldWithHeading(
                                  heading: "PAID NOW",
                                  hindText: "0",
                                  controller: paidNowController,
                                  keyboardType: TextInputType.number,
                                  preFixWidget: Padding(
                                    padding: EdgeInsets.all(12.r),
                                    child: CustomText("₹", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.green)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      sizedBoxHeight(height: 24),
                      _buildSummaryCard(leadCtrl),
                      sizedBoxHeight(height: 40),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(leadCtrl),
            ],
          );
        });
      }),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: primaryColor),
              sizedBoxWidth(width: 8),
              CustomText(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: greyLight8,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBottomActions(LeadController leadCtrl) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: greyLight2),
                ),
              ),
              child: CustomText("Cancel", style: TextStyle(color: greyDart3, fontWeight: FontWeight.bold)),
            ),
          ),
          sizedBoxWidth(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () async {
                if (selectedLead == null || selectedProduct == null) {
                  showToast(message: "Please select lead and product", toastType: ToastType.warning);
                  return;
                }

                final res = await leadCtrl.createLeadOrder(
                  leadId: selectedLead!.id!,
                  productId: selectedProduct!.id!,
                  amount: double.tryParse(amountController.text) ?? 0,
                  quantity: int.tryParse(quantityController.text) ?? 1,
                  paidAmount: double.tryParse(paidNowController.text) ?? 0,
                );

                if (res.isSuccess) {
                  showToast(message: res.message, toastType: ToastType.success);
                  Navigator.pop(context);
                } else {
                  showToast(message: res.message, toastType: ToastType.error);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tertiaryColor,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: leadCtrl.isLoading
                  ? SizedBox(width: 20.w, height: 20.w, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : CustomText("Create Lead Order", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGstOptionDropdown(LeadController leadCtrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              "GST OPTION",
              style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            sizedBoxWidth(width: 4),
            Icon(Icons.lock_outline, size: 14.sp, color: grey),
          ],
        ),
        sizedBoxHeight(height: 7.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: grey.withOpacity(0.15), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedGstOption,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: greyDart2),
              items: gstOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Expanded(child: CustomText(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500))),
                      if (value == "Not Include (0%)")
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(color: greyLight4, borderRadius: BorderRadius.circular(6.r)),
                          child: CustomText("Fixed", style: TextStyle(fontSize: 9.sp, color: greyText, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedGstOption = val!;
                  if (val.contains("5%")) gstPercentController.text = "5";
                  else if (val.contains("12%")) gstPercentController.text = "12";
                  else if (val.contains("18%")) gstPercentController.text = "18";
                  else if (val.contains("28%")) gstPercentController.text = "28";
                  else gstPercentController.text = "0";
                  _calculateTotals();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(LeadController leadCtrl) {
    final calc = leadCtrl.calculationData;
    final isLoading = leadCtrl.isCalcLoading;
    
    debugPrint("SUMMARY CARD BUILD: isLoading=$isLoading, hasData=${calc != null}");
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.calculate_rounded, color: primaryColor, size: 18.sp),
              ),
              sizedBoxWidth(width: 10),
              CustomText(
                "Order & Tax Calculation Summary",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.sp, color: blackText1),
              ),
              const Spacer(),
              if (isLoading)
                SizedBox(width: 15.w, height: 15.w, child: const CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
          sizedBoxHeight(height: 20),
          if (calc == null && !isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomText("Select a product to see calculation summary", style: TextStyle(color: grey, fontStyle: FontStyle.italic)),
            )
          else ...[
            _summaryRow("Product Base Amount", PriceConverter.convertToNumberFormat(calc?.baseSubtotal ?? 0)),
            if (calc != null)
               _summaryRow("Unit Price Details", "${PriceConverter.convertToNumberFormat(calc.baseUnitPrice ?? 0)} + ${PriceConverter.convertToNumberFormat(calc.unitGst ?? 0)} GST", subtitle: "Per unit total: ${PriceConverter.convertToNumberFormat(calc.unitTotal ?? 0)}"),
            _summaryRow("GST Applied (${calc?.gstRate ?? 0}%)", PriceConverter.convertToNumberFormat(calc?.gstAmount ?? 0), 
                subtitle: calc?.isGstIncluded == true ? "(Included)" : "(Not Included)"),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFE2E8F0))),
            _summaryRow("Total (Base + GST)", PriceConverter.convertToNumberFormat(calc?.subtotal ?? 0), isBold: true),
            _summaryRow("Discount Applied", "-${PriceConverter.convertToNumberFormat(calc?.discount ?? 0)}", valueColor: Colors.red),
            sizedBoxHeight(height: 16),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor.withValues(alpha: 0.05), primaryColor.withValues(alpha: 0.08)],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  _summaryRow("Final Payable Amount", PriceConverter.convertToNumberFormat(calc?.finalAmount ?? 0), isBold: true, valueColor: primaryColor),
                  sizedBoxHeight(height: 10),
                  _summaryRow("Amount Paid Now", PriceConverter.convertToNumberFormat(calc?.paidAmount ?? 0), valueColor: green2),
                  const Divider(height: 20),
                  _summaryRow("Remaining Balance", PriceConverter.convertToNumberFormat(calc?.remainingBalance ?? 0), isBold: true, valueColor: green2),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, Color? valueColor, String? subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(label, style: TextStyle(fontSize: 12.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: greyLight8)),
              if (subtitle != null)
                CustomText(subtitle, style: TextStyle(fontSize: 10.sp, color: grey, fontStyle: FontStyle.italic)),
            ],
          ),
          CustomText(value, style: TextStyle(fontSize: 13.sp, fontWeight: isBold ? FontWeight.w800 : FontWeight.bold, color: valueColor ?? blackText1)),
        ],
      ),
    );
  }
}
