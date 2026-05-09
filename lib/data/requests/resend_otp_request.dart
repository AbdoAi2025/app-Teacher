import 'package:teacher_app/enums/otp_channel_enum.dart';

class ResendOtpRequest {
  final String userId;
  final OtpChannel channel;

  ResendOtpRequest({required this.userId, required this.channel});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'channel': channel.toJson(),
      };
}