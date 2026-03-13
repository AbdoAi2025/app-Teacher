import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plan_item_ui_state.dart';
import 'package:teacher_app/services/in_app_purchase_service.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class SubscriptionPlanItem extends StatelessWidget {
  final SubscriptionPlanItemUiState planUiModel;
  final int totalStudentCount;
  final VoidCallback onMonthlyTap;
  final VoidCallback onYearlyTap;
  final int planIndex;

  const SubscriptionPlanItem({
    super.key,
    required this.planUiModel,
    required this.totalStudentCount,
    required this.onMonthlyTap,
    required this.onYearlyTap,
    this.planIndex = 0,
  });


  bool get isCurrentPlan => planUiModel.isCurrentPlan;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      color: _getPlanBackgroundColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: _getBorderSide(context),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 8),
            _buildDescription(context),
            SizedBox(height: 16),
            _buildFeatures(context),
            SizedBox(height: 16),
            if(isCurrentPlan && planUiModel.formattedExpirationDate != null)...{
              _buildExpirationSection(context),
              SizedBox(height: 16),
            },

            if(isCurrentPlan && planUiModel.isExpired())...{
              _buildRenewButton(context),
              SizedBox(height: 16),
            },
            if(planUiModel.isExpired() )
            _buildPricingSection(context),
          ],
        ),
      ),
    );
  }

  BorderSide _getBorderSide(BuildContext context) {
    if (isCurrentPlan) {
      return BorderSide(color: Colors.green, width: 3);
    } else if (planUiModel.isPopular) {
      return BorderSide(color: Theme.of(context).primaryColor, width: 2);
    }
    return BorderSide.none;
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            planUiModel.planName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: planUiModel.isPopular ? Theme.of(context).primaryColor : null,
            ),
          ),
        ),
        if (isCurrentPlan)
          _buildCurrentPlanBadge(context)
        else if (planUiModel.isPopular)
          _buildPopularBadge(context),
      ],
    );
  }

  Widget _buildCurrentPlanBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Current Plan'.tr,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPopularBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Most Popular'.tr,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      planUiModel.localizedDescription,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.grey[600],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFeatures(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureItem(
            context,
            Icons.group,
            planUiModel.formattedStudentLimit,
          ),
        ),
        if (isCurrentPlan) ...[
          SizedBox(width: 12),
          Expanded(
            child: _buildFeatureItem(
              context,
              Icons.person_outline,
              'Total: ${totalStudentCount} ${'students'.tr}',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpirationSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getExpirationTextColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getExpirationTextColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: _getExpirationTextColor(),
              ),
              SizedBox(width: 8),
              Text(
                'Expires on'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _getExpirationTextColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            planUiModel.formattedExpirationDate!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getExpirationTextColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _getRemainingDaysText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getExpirationTextColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewButton(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Icon(
            Icons.refresh,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Renew'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPricingButtons(context),
        // SizedBox(height: 8),
        // _buildTotalPriceBadge(context),
        // SizedBox(height: 12),
        // _buildActionButton(context),
      ],
    );
  }

  Widget _buildPricingButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMonthlyPriceButton(context),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildAnnualPriceButton(context),
        ),
      ],
    );
  }

  Widget _buildMonthlyPriceButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onMonthlyTap(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Monthly'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                planUiModel.formattedMonthlyPrice,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnualPriceButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onYearlyTap(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[100]!,
                Colors.grey[50]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Annual'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                planUiModel.formattedAnnualPrice,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCurrentPlan
              ? Colors.green
              : (planUiModel.isPopular
                  ? Theme.of(context).primaryColor
                  : null),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          isCurrentPlan ? 'Currently Active'.tr : 'Choose Plan'.tr,
          style: TextStyle(
            color: isCurrentPlan || planUiModel.isPopular ? Colors.white : null,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getExpirationTextColor() {

    if (planUiModel.expirationDate == null) return Colors.grey[600]!;

    final now = DateTime.now();
    final expirationDate = planUiModel.expirationDate!;
    final daysRemaining = expirationDate.difference(now).inDays;

    if (daysRemaining < 0) {
      // Expired
      return Colors.red[600]!;
    } else if (daysRemaining <= 5) {
      // Warning (5 days or less)
      return Colors.orange[600]!;
    } else {
      // Good (more than 5 days)
      return Colors.green[600]!;
    }
  }

  String _getRemainingDaysText() {
    if (planUiModel.expirationDate == null) return '';

    final now = DateTime.now();
    final expirationDate = planUiModel.expirationDate!;
    final daysRemaining = expirationDate.difference(now).inDays;

    if (daysRemaining < 0) {
      final daysExpired = daysRemaining.abs();
      if (daysExpired == 1) {
        return '${'Expired'.tr} 1 ${'day ago'.tr}';
      } else {
        return '${'Expired'.tr} $daysExpired ${'days ago'.tr}';
      }
    } else if (daysRemaining == 0) {
      return 'Expires today'.tr;
    } else if (daysRemaining == 1) {
      return '${'Remaining Days'.tr}: 1 ${'day'.tr}';
    } else {
      return '${'Remaining Days'.tr}: $daysRemaining ${'days'.tr}';
    }
  }

  Color _getPlanBackgroundColor(BuildContext context) {
    final colors = [
      Colors.blue.shade50,
      Colors.green.shade50,
      Colors.purple.shade50,
      Colors.orange.shade50,
      Colors.teal.shade50,
      Colors.indigo.shade50,
      Colors.pink.shade50,
      Colors.amber.shade50,
    ];

    if (isCurrentPlan) {
      return Colors.green.shade50;
    } else if (planUiModel.isPopular) {
      return Theme.of(context).primaryColor.withValues(alpha: 0.1);
    }

    return colors[planIndex % colors.length];
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _handleRenewPurchase() async {
    if (!isCurrentPlan) return; // Only allow renewal for current plan

    final purchaseService = Get.find<InAppPurchaseService>();

    // Determine if current plan is monthly or annual based on pricing or plan details
    // For now, we'll show both options and let user choose
    bool? renewalChoice = await _showRenewalChoiceDialog();

    if (renewalChoice != null) {
      bool isMonthly = renewalChoice;

      // Show confirmation dialog with renewal details
      bool? confirmed = await _showRenewalConfirmationDialog(
        isMonthly: isMonthly,
        price: isMonthly ? planUiModel.formattedMonthlyPrice : planUiModel.formattedAnnualPrice,
      );

      if (confirmed == true) {
        await purchaseService.purchaseSubscription(planUiModel, isMonthly: isMonthly);
      }
    }
  }



  Future<bool?> _showRenewalChoiceDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.refresh, color: Theme.of(Get.context!).primaryColor),
            SizedBox(width: 8),
            Text('Renew Subscription'.tr),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your renewal period:'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Plan: ${planUiModel.planName}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            // Monthly option
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.back(result: true),
                icon: Icon(Icons.calendar_view_month, size: 20),
                label: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Renewal'.tr,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      planUiModel.formattedMonthlyPrice,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(Get.context!).primaryColor,
                  foregroundColor: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            // Annual option
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.back(result: false),
                icon: Icon(Icons.calendar_today, size: 20),
                label: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Annual Renewal'.tr,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      planUiModel.formattedAnnualPrice,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRenewalConfirmationDialog({
    required bool isMonthly,
    required String price,
  }) async {
    final renewalType = isMonthly ? 'Monthly' : 'Annual';

    return await Get.dialog<bool>(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.refresh, color: Colors.green),
            SizedBox(width: 8),
            Text('Confirm Renewal'.tr),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Renewal Details'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Plan: ${planUiModel.planName}'),
                  Text('Type: ${renewalType.tr} Renewal'.tr),
                  Text('Price: $price'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your current subscription will be extended for another ${renewalType.toLowerCase()} period.'.tr,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to renew this subscription?'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton.icon(
            onPressed: () => Get.back(result: true),
            icon: Icon(Icons.refresh, size: 18),
            label: Text('Confirm Renewal'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}