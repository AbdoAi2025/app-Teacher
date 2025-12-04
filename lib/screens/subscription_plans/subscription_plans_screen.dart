import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plans_state.dart';
import 'package:teacher_app/screens/subscription_plans/subscription_plans_controller.dart';
import 'package:teacher_app/screens/subscription_plans/widgets/subscription_plan_item.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  late SubscriptionPlansController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SubscriptionPlansController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: 'Subscription Plans'.tr),
      body: Obx(() {
        final state = controller.state.value;
        appLog("SubscriptionPlansScreen state:$state");
        return switch (state.runtimeType) {
          SubscriptionPlansStateLoading => _buildLoadingView(),
          SubscriptionPlansStateSuccess => _buildSuccessView(context, state as SubscriptionPlansStateSuccess),
          SubscriptionPlansStateError => _buildErrorView(context, state as SubscriptionPlansStateError),
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
      itemCount: state.plans.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            'Subscription Plans'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          );
        }
        final plan = state.plans[index - 1];
        final isCurrentPlan = controller.isCurrentPlan(plan);
        return SubscriptionPlanItem(
          plan: plan,
          isCurrentPlan: isCurrentPlan,
          planIndex: index - 1,
          onTap: () => controller.onPlanSelected(plan),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 16),
    );
  }
}