class CourseCategoryModel {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final int courseCount;
  final String slug;

  CourseCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.courseCount,
    required this.slug,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'],
      courseCount: json['courseCount'] ?? 0,
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'iconUrl': iconUrl,
    'courseCount': courseCount,
    'slug': slug,
  };
}
