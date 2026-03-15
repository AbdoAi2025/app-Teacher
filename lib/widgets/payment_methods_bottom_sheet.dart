import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/models/payment_method_model.dart';
import 'package:teacher_app/enums/payment_method_enum.dart';
import 'package:teacher_app/services/payment_method_handler.dart';
import 'package:teacher_app/widgets/app_error_widget.dart';
import 'package:teacher_app/widgets/app_radio_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {

  const PaymentMethodsBottomSheet({super.key,});

  static Future<PaymentMethodModel?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodsBottomSheet(),
    );
  }

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  PaymentMethodModel? selectedPaymentMethod;
  List<PaymentMethodModel> paymentMethods = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final methods =
          await PaymentMethodHandler.getInstance().getAvailablePaymentMethods();
      final enabledMethods = methods.where((method) => method.enabled == true).toList();

      setState(() {
        paymentMethods = enabledMethods;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Payment Methods'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey[200]),
            // Content
            Expanded(
              child: _buildContent(scrollController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    if (isLoading) {
      return LoadingWidget();
    }

    if (errorMessage != null) {
      return AppErrorWidget(
        message: errorMessage!,
        onRetry: _loadPaymentMethods,
      );
    }

    if (paymentMethods.isEmpty) {
      return _buildNoPaymentMethodsContent();
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Payment Method'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                ...paymentMethods.map((method) => _buildPaymentMethodTileWithInstructions(method)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: _continueButton(selectedPaymentMethod != null),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTileWithInstructions(PaymentMethodModel method) {
    final isSelected = selectedPaymentMethod?.id == method.id;

    // Get instructions for this payment method
    final methodEnum = method.paymentMethodEnum;
    String description = '';
    IconData icon = Icons.payment;
    Color color = Theme.of(context).primaryColor;

    switch (methodEnum) {
      case PaymentMethodEnum.CASH:
        description = 'Cash Payment Description'.tr;
        icon = Icons.money;
        color = Colors.orange;
        break;
      case PaymentMethodEnum.ONLINE:
      case PaymentMethodEnum.WALLET:
        description = 'Online Payment Description'.tr;
        icon = Icons.credit_card;
        color = Colors.green;
        break;
      default:
        description = 'Payment Description'.tr;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.05)
              : Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment method selection
              AppRadioWidget(
                value: isSelected,
                label: method.paymentMethodName?.toLowerCase().tr ?? '',
                onChanged: () {
                  setState(() {
                    selectedPaymentMethod = method;
                  });
                },
              ),
              SizedBox(height: 12),
              // Instructions inside the container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildNoPaymentMethodsContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Payment Methods Available'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'No payment methods are currently available. Please try again later or contact support.'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _continueButton(bool isActive) {
    return SizedBox(
      width: double.infinity,
      child: isActive? _activeContinueButton() : _inActiveContinueButton(),
    );
  }

  _activeContinueButton() => PrimaryButtonWidget(
    text: 'Continue'.tr,
    onClick: () {
      Navigator.pop(context, selectedPaymentMethod);
    },
  );
  _inActiveContinueButton() =>  ElevatedButton(
    onPressed:  null,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: AppTextWidget(
      'Continue'.tr,
      style: TextStyle(fontSize: 18),
    ),
  );
}