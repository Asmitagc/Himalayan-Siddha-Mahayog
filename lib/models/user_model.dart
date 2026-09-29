class UserModel {
  final String id;
  final String name;
  final String? profileImageUrl;
  final int unreadNotifications;

  UserModel({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.unreadNotifications = 0,
  });

  String get initials {
    final nameParts = name.trim().split('');
    if (nameParts.length == 1) {
      return nameParts[0].isEmpty ? nameParts[0][0].toUpperCase() : '';
    }
    return (nameParts.first[0] + nameParts.last[0]).toUpperCase();
  }
}
