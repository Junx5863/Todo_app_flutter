class UserData {
  UserData({
    required this.uuid,
    required this.username,
    required this.email,
  });
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        uuid: json['uuid'] == null ? '' : json['uuid'] as String,
        email: json['email'] == null ? '' : json['email'] as String,
        username: json['username'] == null ? '' : json['username'] as String,
      );

  final String uuid;
  final String username;
  final String email;
}
