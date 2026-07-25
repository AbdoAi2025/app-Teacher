class CreateRejoinRequestRequest {
  final String? name;
  final String? toUserId;

  const CreateRejoinRequestRequest({this.name, this.toUserId});

  Map<String, dynamic> toJson() => {
        'name': name,
        'toUserId': toUserId,
      };
}