import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/enums/gender_enum.dart';
import 'package:teacher_app/enums/otp_channel_enum.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/profile/profile_controller.dart';
import 'package:teacher_app/widgets/app_error_widget.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/change_password_bottom_sheet.dart';
import 'package:teacher_app/widgets/otp_verification_bottom_sheet.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppToolbarWidget.appBar(
        title: AppStringsKeys.profile.tr,
        actions: [
          Obx(() {
            final profile = controller.profile.value;
            if (profile == null) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.edit_outlined,
                  color: Theme.of(context).primaryColor),
              tooltip: AppStringsKeys.editProfile.tr,
              onPressed: () async {
                final result =
                    await AppNavigator.navigateToEditProfile(profile);
                if (result == true) controller.loadProfile();
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.errorMessage.value.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.loadProfile,
          );
        }
        final profile = controller.profile.value;
        if (profile == null) return const SizedBox.shrink();
        return _buildContent(context, profile, controller);
      }),
    );
  }

  Widget _buildContent(BuildContext context, TeacherProfileData profile,
      ProfileController controller) {
    return RefreshIndicator(
      onRefresh: controller.loadProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAvatar(context, profile),
            const SizedBox(height: 24),
            _buildInfoSection(context, profile),
            const SizedBox(height: 16),
            _buildVerificationSection(context, profile, controller),
            const SizedBox(height: 16),
            _buildChangePasswordButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: ListTile(
        leading: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
        title: Text(
          AppStringsKeys.changePassword.tr,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => ChangePasswordBottomSheet.show(context),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, TeacherProfileData profile) {
    final initials = _initials(profile.name);
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name ?? '',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (profile.username != null) ...[
          const SizedBox(height: 4),
          Text(
            '@${profile.username}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, TeacherProfileData profile) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _infoTile(
            context,
            icon: Icons.email_outlined,
            label: AppStringsKeys.email.tr,
            value: profile.email ?? '-',
          ),
          _divider(),
          _infoTile(
            context,
            icon: Icons.phone_outlined,
            label: AppStringsKeys.phoneNumber.tr,
            value: profile.phone ?? '-',
          ),
          _divider(),
          _infoTile(
            context,
            icon: Icons.person_search_outlined,
            label: AppStringsKeys.gender.tr,
            value: profile.gender != null
                ? GenderEnum.fromJson(profile.gender!).displayName
                : '-',
          ),
          _divider(),
          _infoTile(
            context,
            icon: Icons.menu_book_outlined,
            label: AppStringsKeys.subject.tr,
            value: profile.subject?.name ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection(
      BuildContext context, TeacherProfileData profile, ProfileController controller) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              AppStringsKeys.verificationStatus.tr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
          ),
          Obx(() {
            final isSending = controller.isSendingOtp.value;
            return Column(
              children: [
                _verificationTile(
                  context,
                  icon: Icons.email_outlined,
                  label: AppStringsKeys.email.tr,
                  verified: profile.emailVerified,
                  isSending: isSending,
                  onVerify: isSending
                      ? null
                      : () => _onVerifyTap(context, controller, OtpChannel.EMAIL, profile.email ?? ''),
                ),
                // _divider(),
                // _verificationTile(
                //   context,
                //   icon: Icons.phone_outlined,
                //   label: AppStringsKeys.phoneNumber.tr,
                //   verified: profile.phoneVerified,
                //   isSending: isSending,
                //   onVerify: isSending
                //       ? null
                //       : () => _onVerifyTap(context, controller, OtpChannel.SMS, profile.phone ?? ''),
                // ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Future<void> _onVerifyTap(
    BuildContext context,
    ProfileController controller,
    OtpChannel channel,
    String channelValue,
  ) async {
    final sent = await controller.sendVerificationOtp(channel);
    if (!context.mounted) return;
    if (!sent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStringsKeys.sendOtpFailed.tr)),
      );
      return;
    }
    final verified = await OtpVerificationBottomSheet.show(
      context,
      userId: controller.profile.value!.userId!,
      otpChannel: channel,
      channelValue: channelValue,
    );
    if (verified) controller.loadProfile();
  }

  Widget _infoTile(BuildContext context,
      {required IconData icon,
      required String label,
      required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool verified,
    bool isSending = false,
    VoidCallback? onVerify,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          if (verified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    AppStringsKeys.verified.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
          else if (isSending)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
            )
          else
            TextButton(
              onPressed: onVerify,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                AppStringsKeys.verify.tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey[100], indent: 52);

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}