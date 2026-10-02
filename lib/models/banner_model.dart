class BannerModel {
  final int id;
  final String title;
  final String? description;
  final String? sliderFile;
  final String? videoFile;
  final String sliderType;
  final String? buttonLabel;
  final String? buttonNavigation;
  final String target;
  final int displayOrder;
  final int status;

  const BannerModel({
    required this.id,
    required this.title,
    this.description,
    this.sliderFile,
    this.videoFile,
    required this.sliderType,
    this.buttonLabel,
    this.buttonNavigation,
    required this.target,
    required this.displayOrder,
    required this.status,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: _toInt(json['id']),
      title: json['title']?.toString().trim() ?? '',
      description: _toStringOrNull(json['description']),
      sliderFile: _toStringOrNull(json['slider_file']),
      videoFile: _toStringOrNull(json['video_file']),
      sliderType: json['slider_type']?.toString().trim().toLowerCase() ?? '',
      buttonLabel: _toStringOrNull(json['button_label']),
      buttonNavigation: _toStringOrNull(json['button_navigation']),
      target: json['banner_target']?.toString().trim().toLowerCase() ?? '',
      displayOrder: _toInt(json['display_order']),
      status: _toInt(json['status']),
    );
  }

  static String? _toStringOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return text;
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }
}