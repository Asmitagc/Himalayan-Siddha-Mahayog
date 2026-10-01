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

  BannerModel({
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
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      sliderFile: json['slider_file']?.toString(),
      videoFile: json['video_file']?.toString(),
      sliderType: json['slider_type']?.toString() ?? '',
      buttonLabel: json['button_label']?.toString(),
      buttonNavigation: json['button_navigation']?.toString(),
      target: json['banner_target']?.toString() ?? '',
      displayOrder: _toInt(json['display_order']),
      status: _toInt(json['status']),
    );
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

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
