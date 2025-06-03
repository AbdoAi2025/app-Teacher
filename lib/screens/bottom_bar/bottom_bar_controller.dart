import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BottomBarController extends GetxController{


  Rx<int> selectTab = 0.obs;


  void onTabTapped(int index){
    selectTab.value = index;
  }

}
