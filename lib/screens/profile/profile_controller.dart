import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/domain/usecases/get_teacher_profile_use_case.dart';
import 'package:teacher_app/domain/usecases/resend_otp_use_case.dart';
import 'package:teacher_app/enums/otp_channel_enum.dart';

class ProfileController extends GetxController {
  final _useCase = GetTeacherProfileUseCase();

  Rx<TeacherProfileData?> profile = Rx(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isSendingOtp = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<bool> sendVerificationOtp(OtpChannel channel) async {
    final userId = profile.value?.userId;
    if (userId == null) return false;
    isSendingOtp.value = true;
    final result = await ResendOtpUseCase().execute(userId: userId, channel: channel);
    isSendingOtp.value = false;
    return result.isSuccess;
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _useCase.execute();

    if (result.isSuccess) {
      profile.value = result.value;
    } else {
      errorMessage.value = result.error?.toString() ?? 'error'.tr;
    }

    isLoading.value = false;
  }
}