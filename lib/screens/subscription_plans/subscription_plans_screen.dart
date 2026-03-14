import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/students_list/states/students_state.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plan_item_ui_state.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plans_state.dart';
import 'package:teacher_app/screens/subscription_plans/subscription_plans_controller.dart';
import 'package:teacher_app/screens/subscription_plans/widgets/subscription_plan_item.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';

import '../../domain/usecases/get_my_students_list_use_case.dart';
import '../../enums/payment_provider_type.dart';
import '../../requests/get_my_students_request.dart';
import '../../services/in_app_purchase_service.dart';
import '../../services/paymob_native_service.dart';
import '../students_list/students_controller.dart';
import 'bottomsheets/purchase_confirmation_bottom_sheet.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});
  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {

  // late SubscriptionPlansController controller = Get.put(SubscriptionPlansController());
  late SubscriptionPlansController controller = Get.find();

  // Initialize in-app purchase service
  InAppPurchaseService purchaseService = Get.put(InAppPurchaseService());

  @override
  void initState() {
    super.initState();
    purchaseService.initializePurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: 'Subscription Plans'.tr),
      body: Obx(() {
        final state = controller.state.value;
        appLog("SubscriptionPlansScreen state:$state");
        return switch (state) {
          SubscriptionPlansStateLoading() => _buildLoadingView(),
          SubscriptionPlansStateSuccess() => _buildSuccessView(context, state),
          SubscriptionPlansStateError() => _buildErrorView(context, state),
          _ => _buildEmptyView(),
        };
      }),
    );
  }


  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessView(BuildContext context, SubscriptionPlansStateSuccess state) {
    return RefreshIndicator(
      onRefresh: controller.loadSubscriptionPlans,
      child: _buildAllPlansListView(context, state),
    );
  }

  Widget _buildErrorView(BuildContext context, SubscriptionPlansStateError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Error loading subscription plans'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            state.error?.toString() ?? 'Unknown error'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: controller.refreshSubscriptionPlans,
            icon: Icon(Icons.refresh),
            label: Text('Retry'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return SizedBox.shrink();
  }

  Widget _buildEmptyPlansView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No subscription plans available'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: controller.refreshSubscriptionPlans,
            child: Text('Retry'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildAllPlansListView(BuildContext context, SubscriptionPlansStateSuccess state) {
    if (state.plans.isEmpty) {
      return _buildEmptyPlansView(context);
    }
    return ListView.separated(
      padding: EdgeInsets.only(top: 16, bottom: 30, left: 16, right: 16),
      itemCount: state.plans.length, // +1 for header
      itemBuilder: (context, index) {

        final plan = state.plans[index];

        if(index == 0 ){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(plan.isCurrentPlan)...{
                _title('Current Plan'.tr,),
              }else ...{
                _title('Subscription Plans'.tr,),
              },
              SubscriptionPlanItem(
                planUiModel: plan,
                totalStudentCount: state.totalStudentCount,
                planIndex: index - 1,
                onMonthlyTap: () => onSubscribeTap(plan , true , state.totalStudentCount),
                onYearlyTap: () => onSubscribeTap(plan , false , state.totalStudentCount),
              ),
               if(plan.isCurrentPlan)
              _title('Subscription Plans'.tr,),
            ],
          );
        }

        return SubscriptionPlanItem(
          planUiModel: plan,
          totalStudentCount: state.totalStudentCount,
          planIndex: index,
          onMonthlyTap: () => onSubscribeTap(plan , true , state.totalStudentCount),
          onYearlyTap: () => onSubscribeTap(plan , false , state.totalStudentCount),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 16),
    );
  }

  _title(String title) => Text(
    title,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
    ),
  );

   onSubscribeTap(SubscriptionPlanItemUiState plan , bool isMonthly, int totalStudentCount) async {

     var teacherStudentsCount = totalStudentCount;
    if(teacherStudentsCount > plan.studentLimit ) {
      showErrorMessagePopup("Can't subscribe this plan because you have $teacherStudentsCount students greater than plan limit (${plan.studentLimit})");
      return;
    }

    //if free plan and plan limit less than student limit, call subscribe direct without payment
     if(plan.monthlyPrice == 0.0 && plan.studentLimit > teacherStudentsCount){
       showDialogLoading();
        var subscribeResult = await controller.subscribe(plan , isMonthly);
       hideDialogLoading();
       if(subscribeResult.isSuccess) {
         onSubscribeSuccess(plan);
       } else {
         showErrorMessagePopup(subscribeResult.error?.toString() ?? "failed to complete subscription".tr);
       }
       return;
     }

     // Show confirmation bottom sheet
     bool? confirmed = await PurchaseConfirmationBottomSheet.show(
       context,
       planUiModel: plan,
       title: isMonthly ? 'Monthly Plan'.tr : 'Annual Plan'.tr,
       price: isMonthly ? plan.formattedMonthlyPrice : plan.formattedAnnualPrice,
       isMonthly: isMonthly,
     );

     if (confirmed == true) {
       showDialogLoading();
       var result = await controller.initiateSubscriptionProcess(plan , isMonthly);
       hideDialogLoading();
       var model = result.data;
       if(result.isSuccess && model != null){
         if(model.paymentProviderType == PaymentProviderType.PAYMOB){
           final result = await PaymobNativeService.payWithPaymob(
             clientSecret:  model.paymentKey ?? "",
           );
           appLog("onSubscribeTap PaymobNativeService.payWithPaymob result:$result");

           // if(result.success){
           //   showDialogLoading();
           //   await Future.delayed(Duration(seconds: 5));
           //   hideDialogLoading();
           //   onSubscribeSuccess(plan);
           // }else {
           //   showErrorMessagePopup(result.error?.toString() ?? "failed to complete payment process".tr);
           // }
           showDialogLoading();
           var verifyPaymentResult = await controller.verifyPayment(model.orderId , model.merchantOrderId);
           hideDialogLoading();
           if(verifyPaymentResult.isSuccess){
             onSubscribeSuccess(plan);
           }else {
             showErrorMessagePopup("failed to complete payment process".tr);
           }
         }
       }else {
         showErrorMessagePopup(result.error?.toString() ?? "failed to complete payment process".tr);
       }

       // await purchaseService.purchaseSubscription(plan, isMonthly: isMonthly);
     }
   }

  Future<void> onSubscribeSuccess(SubscriptionPlanItemUiState plan) async {
    await showSuccessMessagePopup("Subscription process completed successfully".tr);
    controller.refreshSubscriptionPlans();
  }

}