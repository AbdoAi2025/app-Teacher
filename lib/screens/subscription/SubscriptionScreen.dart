import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import '../../models/subscription_product_model.dart';
import '../../models/subscription_plan_model.dart';
import '../../models/current_plan_state.dart';
import '../../themes/app_colors.dart';
import '../../widgets/confirm_dailog_widget.dart';
import '../../widgets/app_toolbar_widget.dart';
import 'SubscriptionController.dart';

class SubscriptionScreen extends StatefulWidget {

  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  final controller = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppToolbarWidget.appBar(
        onLeadingClick: () => AppNavigator.back(),
        title: 'Subscribe'.tr,
        actions: [
          TextButton(
            onPressed: controller.restorePurchases,
            child: Text(
              'Restore'.tr,
              style: TextStyle(color: AppColors.appMainColor),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentPlanSection(controller),
                    const SizedBox(height: 30),
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildFeaturesList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomSection(controller),
          ],
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unlock Premium Features'.tr,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.appMainColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Get unlimited access to all features and enhance your teaching experience'.tr,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Unlimited student management',
      // 'Advanced reporting and analytics',
      // 'Export data in multiple formats',
      // 'Priority customer support',
      // 'Ad-free experience',
      // 'Cloud backup and sync',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What you get:'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.appMainColor,
          ),
        ),
        const SizedBox(height: 15),
        ...features.map((feature) => _buildFeatureItem(feature.tr)),
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.appMainColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans(SubscriptionController controller) {
    return Obx(() {
      if (controller.isLoadingPlans.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.plansError.value.isNotEmpty) {
        return Column(
          children: [
            Text(
              'Failed to load plans'.tr,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: controller.refreshSubscriptionPlans,
              child: Text('Retry'.tr),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your plan:'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.appMainColor,
            ),
          ),
          const SizedBox(height: 15),
          ...controller.availablePlans.map((plan) =>
            _buildBackendPlanCard(plan, controller)),
        ],
      );
    });
  }

  Widget _buildSubscriptionPlanCard(
    SubscriptionProductModel product,
    SubscriptionController controller,
  ) {
    return Obx(() {
      final isSelected = controller.selectedProduct.value?.id == product.id;

      return GestureDetector(
        onTap: () => controller.selectProduct(product),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.appMainColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? AppColors.appMainColor.withOpacity(0.05) : Colors.white,
          ),
          child: Stack(
            children: [
              if (product.isRecommended)
                Positioned(
                  top: 0,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.appMainColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Recommended'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.appMainColor : Colors.grey[400]!,
                          width: 2,
                        ),
                        color: isSelected ? AppColors.appMainColor : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                product.title.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              if (product.savingsText.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    product.savingsText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.description.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appMainColor,
                          ),
                        ),
                        Text(
                          product.formattedDuration,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomSection(SubscriptionController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isPurchasing.value
                  ? null
                  : () => _showSubscriptionPlansBottomSheet(controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appMainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: controller.isPurchasing.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Obx(() {
                      final currentPlan = controller.currentPlanState.value;
                      final isFreePlan = currentPlan is CurrentPlanStateSuccess &&
                                       currentPlan.subscriptionPlan.planCode == 'FREE';

                      return Text(
                        isFreePlan ? 'Subscribe Now'.tr : 'Upgrade'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
            ),
          )),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: controller.goToSubscriptionTerms,
                child: Text(
                  'Terms of Service'.tr,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                '•',
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton(
                onPressed: controller.goToPrivacyPolicy,
                child: Text(
                  'Privacy Policy'.tr,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanSection(SubscriptionController controller) {
    return Obx(() {
      return switch (controller.currentPlanState.value) {
        CurrentPlanStateLoading() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text(
                'Loading current plan...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        CurrentPlanStateError(error: var error) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Failed to load current plan'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.refreshCurrentSubscriptionPlan,
                child: Text('Retry'.tr),
              ),
            ],
          ),
        ),
        CurrentPlanStateSuccess(subscriptionPlan: var plan) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: plan.hasValidSubscription
                  ? [AppColors.appMainColor.withAlpha(30), AppColors.appMainColor.withAlpha(10)]
                  : [Colors.orange.withAlpha(30), Colors.orange.withAlpha(10)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: plan.hasValidSubscription
                  ? AppColors.appMainColor.withAlpha(100)
                  : Colors.orange.withAlpha(100),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: plan.hasValidSubscription
                          ? AppColors.appMainColor
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plan.hasValidSubscription ? 'Active'.tr : 'Expired'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (plan.hasValidSubscription)
                    Icon(
                      Icons.verified,
                      color: AppColors.appMainColor,
                      size: 24,
                    )
                  else
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Current Plan'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                plan.planName ?? 'Unknown Plan',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildPlanInfoItem(
                      'Student Usage'.tr,
                      '${plan.totalStudentCount ?? 0}/${plan.studentLimit != null && plan.studentLimit! > 0 ? plan.studentLimit.toString() : 'Unlimited'}',
                      Icons.people,
                    ),
                  ),
                  if (plan.planCode != 'FREE') ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPlanInfoItem(
                        plan.hasValidSubscription ? 'Days Remaining'.tr : 'Expired'.tr,
                        plan.hasValidSubscription
                            ? '${plan.daysRemaining} days'
                            : 'Renew now'.tr,
                        plan.hasValidSubscription ? Icons.schedule : Icons.refresh,
                      ),
                    ),
                  ],
                ],
              ),
              if (plan.subscriptionExpireDate != null && plan.planCode != 'FREE') ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(150),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        plan.hasValidSubscription
                            ? 'Expires on'.tr
                            : 'Expired on'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(plan.subscriptionExpireDate!),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (plan.planCode != 'FREE' && (!plan.hasValidSubscription || plan.daysRemaining < 5)) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showSubscriptionPlansBottomSheet(controller),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Renew Subscription'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      };
    });
  }

  Widget _buildPlanInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackendPlanCard(
    SubscriptionPlanModel plan,
    SubscriptionController controller,
  ) {
    return Obx(() {
      final isSelected = controller.selectedPlan.value?.planCode == plan.planCode;

      return GestureDetector(
        onTap: () => controller.selectSubscriptionPlan(plan),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.appMainColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? AppColors.appMainColor.withOpacity(0.05) : Colors.white,
          ),
          child: Stack(
        children: [
          if (plan.isPremium)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.appMainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'Recommended'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.planName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan.studentLimitText,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!plan.isFree)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (plan.monthlyPrice != null)
                            Text(
                              plan.formattedMonthlyPrice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appMainColor,
                              ),
                            ),
                          if (plan.yearlyPrice != null)
                            Text(
                              plan.formattedYearlyPrice,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      )
                    else
                      Text(
                        'Free',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ...plan.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.appMainColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
          ),
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showSubscriptionPlansBottomSheet(SubscriptionController controller) {
    // Initialize selection with current plan when bottom sheet opens
    controller.initializeSelectionWithCurrentPlan();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubscriptionPlans(controller),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isPurchasing.value
                          ? null
                          : () {
                              Navigator.pop(context);
                              controller.purchaseSelectedProduct();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appMainColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: controller.isPurchasing.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Obx(() {
                              final currentPlan = controller.currentPlanState.value;
                              final isFreePlan = currentPlan is CurrentPlanStateSuccess &&
                                               currentPlan.subscriptionPlan.planCode == 'FREE';

                              return Text(
                                isFreePlan ? 'Subscribe Now'.tr : 'Upgrade'.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}