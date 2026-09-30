class CourseModel {
  final String id;
  final String title;
  final String subtitle;
  final String? mediaPath;
  final bool isVideo;

  CourseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.mediaPath,
    this.isVideo = false,
  });
}
