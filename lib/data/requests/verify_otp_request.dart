import 'package:teacher_app/enums/otp_channel_enum.dart';

class VerifyOtpRequest {
  final String userId;
  final String code;
  final OtpChannel channel;

  VerifyOtpRequest({
    required this.userId,
    required this.code,
    required this.channel,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'code': code,
        'channel': channel.toJson(),
      };
}