import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/resend_otp_use_case.dart';
import 'package:teacher_app/domain/usecases/verify_forgot_password_otp_use_case.dart';
import 'package:teacher_app/domain/usecases/verify_otp_use_case.dart';
import 'package:teacher_app/enums/otp_channel_enum.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/reset_password_bottom_sheet.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/navigation/app_routes.dart';

class OtpVerificationBottomSheet extends StatefulWidget {
  final String userId;
  final OtpChannel otpChannel;
  final String channelValue;
  final bool isForgot;
  final bool requestInitialOtp;

  const OtpVerificationBottomSheet({
    super.key,
    required this.userId,
    required this.otpChannel,
    required this.channelValue,
    this.isForgot = false,
    this.requestInitialOtp = false,
  });


  static Future<bool> sendVerificationOtp(String userId , OtpChannel channel) async {
    final result = await ResendOtpUseCase().execute(userId: userId, channel: channel);
    return result.isSuccess;
  }

  static Future<bool> show(
    BuildContext context, {
    required String userId,
    required OtpChannel otpChannel,
    required String channelValue,
    bool isForgot = false,
    bool requestInitialOtp = false,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OtpVerificationBottomSheet(
        userId: userId,
        otpChannel: otpChannel,
        channelValue: channelValue,
        isForgot: isForgot,
        requestInitialOtp: requestInitialOtp,
      ),
    );
    return result ?? false;
  }

  static void showRequireVerify(
    BuildContext context, {
    required String userId,
    required VoidCallback onSuccess,
  }) {
    showConfirmationMessage(
      AppStringsKeys.requireVerifyMessage.tr,
      () => _resendAndVerify(context, userId: userId, onSuccess: onSuccess),
      barrierDismissible: false,
      positiveButtonText: AppStringsKeys.verifyNow.tr,
      negativeButtonText: AppStringsKeys.skip.tr,
      onCancel: () => AppNavigator.navigateToHome()
    );
  }

  static Future<void> _resendAndVerify(
    BuildContext context, {
    required String userId,
    required VoidCallback onSuccess,
  }) async {
    showDialogLoading();
    final result = await ResendOtpUseCase().execute(
      userId: userId,
      channel: OtpChannel.EMAIL,
    );
    hideDialogLoading();

    if (!context.mounted) return;

    if (result.isSuccess) {
      final channelValue = result.value?.data ?? '';
      final verified = await show(
        context,
        userId: userId,
        otpChannel: OtpChannel.EMAIL,
        channelValue: channelValue,
      );
      if (verified) onSuccess();
    } else {
      showErrorMessageEx(result.error);
    }
  }

  @override
  State<OtpVerificationBottomSheet> createState() =>
      _OtpVerificationBottomSheetState();
}

class _OtpVerificationBottomSheetState
    extends State<OtpVerificationBottomSheet> {
  static const int _digitCount = 4;
  static const int _resendTimeoutSeconds = 120;

  final List<TextEditingController> _controllers =
      List.generate(_digitCount, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_digitCount, (_) => FocusNode());

  final _verifyUseCase = VerifyOtpUseCase();
  final _resendUseCase = ResendOtpUseCase();
  final _verifyForgotUseCase = VerifyForgotPasswordOtpUseCase();

  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  int _remainingSeconds = _resendTimeoutSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.requestInitialOtp) {
      _remainingSeconds = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) => _onResend());
    } else {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _remainingSeconds = _resendTimeoutSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _code =>
      _controllers.map((c) => c.text).join();

  bool get _isCodeComplete => _code.length == _digitCount;

  Future<void> _onVerify() async {
    if (!_isCodeComplete || _isVerifying) return;
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    if (widget.isForgot) {
      final result = await _verifyForgotUseCase.execute(
        userId: widget.userId,
        code: _code,
      );
      if (!mounted) return;
      if (result.isSuccess) {
        final resetToken = result.value!.resetToken;
        Navigator.pop(context, true);
        if (context.mounted) {
          await ResetPasswordBottomSheet.show(context, resetToken: resetToken);
        }
      } else {
        setState(() {
          _isVerifying = false;
          _errorMessage = AppStringsKeys.invalidOrExpiredCodePleaseTryAgain.tr;
        });
      }
    } else {
      final result = await _verifyUseCase.execute(
        userId: widget.userId,
        code: _code,
        channel: widget.otpChannel,
      );
      if (!mounted) return;
      if (result.isSuccess) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _isVerifying = false;
          _errorMessage = AppStringsKeys.invalidOrExpiredCodePleaseTryAgain.tr;
        });
      }
    }
  }

  Future<void> _onResend() async {
    if (_remainingSeconds > 0 || _isResending) return;
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    final result = await _resendUseCase.execute(
      userId: widget.userId,
      channel: widget.otpChannel,
    );

    if (!mounted) return;

    setState(() => _isResending = false);

    if (result.isSuccess) {
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStringsKeys.codeResentSuccessfully.tr)),
      );
    } else {
      setState(
          () => _errorMessage = AppStringsKeys.failedToResendCode.tr);
    }
  }

  void _onDigitChanged(String value, int index) {
    if (value.length == 1 && index < _digitCount - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSubtitle(),
                    const SizedBox(height: 8),
                    _buildChannelValue(),
                    const SizedBox(height: 28),
                    _buildOtpFields(),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      _buildError(),
                    ],
                    const SizedBox(height: 28),
                    _buildVerifyButton(),
                    if (!widget.isForgot) ...[
                      const SizedBox(height: 16),
                      _buildResendRow(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.lock_outline,
              color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 12),
          Text(
            AppStringsKeys.otpVerification.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(Icons.close, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    final key = widget.otpChannel == OtpChannel.EMAIL
        ? 'Enter the code sent to your email'
        : 'Enter the code sent to your phone';
    return Text(
      key.tr,
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildChannelValue() {
    return Text(
      widget.channelValue,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOtpFields() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_digitCount, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(event, index),
            child: SizedBox(
              width: 56,
              height: 64,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onChanged: (value) => _onDigitChanged(value, index),
              ),
            ),
          ),
        );
      }),
    ),
    );
  }

  Widget _buildError() {
    return Text(
      _errorMessage!,
      style: const TextStyle(color: Colors.red, fontSize: 13),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildVerifyButton() {
    final isActive = _isCodeComplete && !_isVerifying;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive ? _onVerify : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isVerifying
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(
                AppStringsKeys.verify.tr,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildResendRow() {
    final canResend = _remainingSeconds <= 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!canResend) ...[
          Text(
            '${AppStringsKeys.resendIn.tr} ',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          Text(
            _formattedTime,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ] else
          TextButton(
            onPressed: _isResending ? null : _onResend,
            child: _isResending
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Text(
                    AppStringsKeys.resendCode.tr,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
          ),
      ],
    );
  }
}