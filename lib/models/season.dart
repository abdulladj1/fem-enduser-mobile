class SeasonDetailResponse {
  final int status;
  final String message;
  final Season data;

  SeasonDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) {
    return SeasonDetailResponse(
      status: json['status'],
      message: json['message'],
      data: Season.fromJson(json['data']),
    );
  }
}

class Season {
  final String id;
  final String name;
  final String status;
  final SeasonImage logo;
  final SeasonImage banner;
  final String createdAt;
  final String updatedAt;

  Season({
    required this.id,
    required this.name,
    required this.status,
    required this.logo,
    required this.banner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      logo: SeasonImage.fromJson(json['logo']),
      banner: SeasonImage.fromJson(json['banner']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class SeasonImage {
  final String id;
  final String name;
  final int size;
  final String url;
  final String type;
  final bool isPrivate;
  final String providerKey;

  SeasonImage({
    required this.id,
    required this.name,
    required this.size,
    required this.url,
    required this.type,
    required this.isPrivate,
    required this.providerKey,
  });

  factory SeasonImage.fromJson(Map<String, dynamic> json) {
    return SeasonImage(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      url: json['url'],
      type: json['type'],
      isPrivate: json['isPrivate'],
      providerKey: json['providerKey'],
    );
  }
}