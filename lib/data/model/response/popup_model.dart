class PopupModel {
  int? id;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  PopupModel({
    this.id,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a PopupModel from JSON
  factory PopupModel.fromJson(Map<String, dynamic> json) {
    return PopupModel(
      id: json['id'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Method to convert a PopupModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
