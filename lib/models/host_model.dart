class HostModel {
  final String id;
  final String name;
  final String ssid;
  final double pricePerGB;
  final double rating;
  final double distance;
  final int availableGB;
  final bool isActive;

  const HostModel({
    required this.id,
    required this.name,
    required this.ssid,
    required this.pricePerGB,
    required this.rating,
    required this.distance,
    required this.availableGB,
    required this.isActive,
  });

  factory HostModel.fromMap(Map<String, dynamic> map) {
    return HostModel(
      id: map['id'] as String,
      name: map['name'] as String,
      ssid: map['ssid'] as String,
      pricePerGB: (map['pricePerGB'] as num).toDouble(),
      rating: (map['rating'] as num).toDouble(),
      distance: (map['distance'] as num).toDouble(),
      availableGB: map['availableGB'] as int,
      isActive: map['isActive'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ssid': ssid,
      'pricePerGB': pricePerGB,
      'rating': rating,
      'distance': distance,
      'availableGB': availableGB,
      'isActive': isActive,
    };
  }

  HostModel copyWith({
    String? id,
    String? name,
    String? ssid,
    double? pricePerGB,
    double? rating,
    double? distance,
    int? availableGB,
    bool? isActive,
  }) {
    return HostModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ssid: ssid ?? this.ssid,
      pricePerGB: pricePerGB ?? this.pricePerGB,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      availableGB: availableGB ?? this.availableGB,
      isActive: isActive ?? this.isActive,
    );
  }
}
