import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/widgets/app_error_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../../data/responses/current_subscription_plan_response.dart';
import '../../../navigation/app_navigator.dart';
import '../../subscription_plans/states/subscription_plan_item_ui_state.dart';
import '../../subscription_plans/states/subscription_plans_state.dart';
import '../../subscription_plans/subscription_plans_controller.dart';
import '../../subscription_plans/widgets/subscription_plan_item.dart';

class CurrentSubscriptionPlanBottomSheet extends StatelessWidget {
  final SubscriptionPlansController subscriptionPlansController;

  const CurrentSubscriptionPlanBottomSheet({
    super.key,
    required this.subscriptionPlansController,
  });

  static void show(BuildContext context, SubscriptionPlansController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrentSubscriptionPlanBottomSheet(
        subscriptionPlansController: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
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
                    Icons.subscriptions,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'My Subscription'.tr,
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
              child:  _buildSubscriptionContent(context, scrollController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionContent(BuildContext context, ScrollController scrollController) {
    // Check if we have current subscription data
    return Obx((){

      var state = subscriptionPlansController.state.value;

      if(state is SubscriptionPlansStateSuccess){

        var currentPlan = state.getCurrentPlanUiModel();
        if (currentPlan == null) {
          return _buildNoSubscriptionContent(context);
        }

        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SubscriptionPlanItem(planUiModel: currentPlan, isCurrentPlan: true, onTap: (){}),
              // _buildCurrentPlanCard(context, currentPlan),
              // _buildSubscriptionDetails(context, currentPlan),
              _buildActionButtons(context),
            ],
          ),
        );
      }

      if(state is SubscriptionPlansStateLoading){
        return LoadingWidget();
      }

      if(state is SubscriptionPlansStateError){
       return AppErrorWidget(message: state.error?.toString() ?? "",);
      }

      return _buildNoSubscriptionContent(context);
    });


  }

  Widget _buildNoSubscriptionContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
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
            'No Active Subscription'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'You don\'t have an active subscription plan. Browse available plans to get started.'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                AppNavigator.navigateToSubscriptionPlans();
              },
              icon: Icon(Icons.explore, size: 20),
              label: Text('Browse Plans'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard(BuildContext context, SubscriptionPlanItemUiState currentPlan) {

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Current Plan'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            currentPlan.planName ?? 'Subscription Plan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            currentPlan.descriptionAr ?? 'Active subscription plan',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetails(BuildContext context, dynamic currentPlan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Details'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        _buildDetailItem(
          context,
          'Plan Name'.tr,
          currentPlan.planName ?? 'N/A',
          Icons.label_outline,
        ),
        _buildDetailItem(
          context,
          'Student Limit'.tr,
          currentPlan.formattedStudentLimit ?? 'N/A',
          Icons.group_outlined,
        ),
        if (currentPlan.formattedExpirationDate != null)
          _buildDetailItem(
            context,
            'Expires On'.tr,
            currentPlan.formattedExpirationDate!,
            Icons.schedule_outlined,
            valueColor: _getExpirationColor(currentPlan),
          ),
        _buildDetailItem(
          context,
          'Status'.tr,
          _getSubscriptionStatus(currentPlan),
          Icons.info_outline,
          valueColor: _getStatusColor(currentPlan),
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigator.pop(context);
              AppNavigator.navigateToSubscriptionPlans();
            },
            icon: Icon(Icons.upgrade, size: 20),
            label: Text('Manage Subscription'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getExpirationColor(dynamic currentPlan) {
    if (currentPlan.expirationDate == null) return Colors.grey[600]!;

    final now = DateTime.now();
    final expirationDate = currentPlan.expirationDate!;
    final daysRemaining = expirationDate.difference(now).inDays;

    if (daysRemaining < 0) {
      return Colors.red[600]!;
    } else if (daysRemaining <= 5) {
      return Colors.orange[600]!;
    } else {
      return Colors.green[600]!;
    }
  }

  Color _getStatusColor(dynamic currentPlan) {
    if (currentPlan.expirationDate == null) return Colors.grey[600]!;

    final now = DateTime.now();
    final expirationDate = currentPlan.expirationDate!;
    final daysRemaining = expirationDate.difference(now).inDays;

    if (daysRemaining < 0) {
      return Colors.red[600]!;
    } else {
      return Colors.green[600]!;
    }
  }

  String _getSubscriptionStatus(dynamic currentPlan) {
    if (currentPlan.expirationDate == null) return 'Unknown'.tr;

    final now = DateTime.now();
    final expirationDate = currentPlan.expirationDate!;
    final daysRemaining = expirationDate.difference(now).inDays;

    if (daysRemaining < 0) {
      return 'Expired'.tr;
    } else if (daysRemaining <= 5) {
      return 'Expiring Soon'.tr;
    } else {
      return 'Active'.tr;
    }
  }
}