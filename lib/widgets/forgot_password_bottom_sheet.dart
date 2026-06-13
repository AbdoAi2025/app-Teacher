import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/forgot_password_use_case.dart';
import 'package:teacher_app/enums/otp_channel_enum.dart';
import 'package:teacher_app/widgets/otp_verification_bottom_sheet.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  final String initialIdentifier;

  const ForgotPasswordBottomSheet({super.key, this.initialIdentifier = ''});

  static Future<void> show(BuildContext context, {String initialIdentifier = ''}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => ForgotPasswordBottomSheet(initialIdentifier: initialIdentifier),
    );
  }

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  late final TextEditingController _identifierController;
  final _useCase = ForgotPasswordUseCase();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController(text: widget.initialIdentifier);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty) {
      setState(() => _errorMessage = AppStringsKeys.identifierIsRequired.tr);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _useCase.execute(identifier: identifier);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.isSuccess) {
      final data = result.value!;
      Navigator.pop(context);
      if (context.mounted) {
        await OtpVerificationBottomSheet.show(
          context,
          userId: data.userId,
          otpChannel: OtpChannel.EMAIL,
          channelValue: data.otpSentTo,
          isForgot: true,
        );
      }
    } else {
      final ex = result.error;
      setState(() => _errorMessage = ex?.toString() ?? AppStringsKeys.somethingWentWrong.tr);
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStringsKeys.enterYourEmailOrUsername.tr,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    _buildIdentifierField(),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 24),
                    _buildSendButton(),
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
          Icon(Icons.lock_reset, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 12),
          Text(
            AppStringsKeys.forgotPassword.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentifierField() {
    return TextField(
      controller: _identifierController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _onSend(),
      decoration: InputDecoration(
        labelText: AppStringsKeys.emailOrUsername.tr,
        hintText: AppStringsKeys.enterYourEmailOrUsername.tr,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onSend,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                AppStringsKeys.sendResetCode.tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}