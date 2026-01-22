class AppSettings {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final int scanPower;

  const AppSettings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.scanPower = 30,
  });

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    int? scanPower,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      scanPower: scanPower ?? this.scanPower,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'scanPower': scanPower,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      scanPower: json['scanPower'] ?? 30,
    );
  }
}
