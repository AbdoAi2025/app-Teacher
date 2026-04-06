import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../domain/managers/current_subscription_plan_manager.dart';

class BottomBarController extends GetxController{

  Rx<int> selectTab = 0.obs;

  // Access to subscription plan manager
  CurrentSubscriptionPlanManager get subscriptionManager => CurrentSubscriptionPlanManager.instance;

  @override
  void onInit() {
    super.onInit();
    _initSubscriptionManager();
  }

  onDispose(){
    subscriptionManager.clear();
  }


  Future<void> _initSubscriptionManager() async {
    await subscriptionManager.initialize();
  }

  void onTabTapped(int index){
    selectTab.value = index;
  }

  void refreshSubscriptionData() {
    subscriptionManager.refresh();
  }

}
