class MarketStats {
  const MarketStats({
    required this.totalDelegatedVolume,
    required this.activeDelegates,
    required this.liquidityRate,
    required this.marketIndex,
    this.trendPoints = const [],
  });

  final int totalDelegatedVolume;
  final int activeDelegates;
  final double liquidityRate;
  final double marketIndex;
  final List<double> trendPoints;

  MarketStats copyWith({
    int? totalDelegatedVolume,
    int? activeDelegates,
    double? liquidityRate,
    double? marketIndex,
    List<double>? trendPoints,
  }) {
    return MarketStats(
      totalDelegatedVolume: totalDelegatedVolume ?? this.totalDelegatedVolume,
      activeDelegates: activeDelegates ?? this.activeDelegates,
      liquidityRate: liquidityRate ?? this.liquidityRate,
      marketIndex: marketIndex ?? this.marketIndex,
      trendPoints: trendPoints ?? this.trendPoints,
    );
  }

  factory MarketStats.fromJson(Map<String, dynamic> json) {
    return MarketStats(
      totalDelegatedVolume: (json['totalDelegatedVolume'] as num?)?.toInt() ?? 0,
      activeDelegates: (json['activeDelegates'] as num?)?.toInt() ?? 0,
      liquidityRate: (json['liquidityRate'] as num?)?.toDouble() ?? 0,
      marketIndex: (json['marketIndex'] as num?)?.toDouble() ?? 0,
      trendPoints: (json['trendPoints'] as List<dynamic>?)
              ?.map((value) => (value as num).toDouble())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDelegatedVolume': totalDelegatedVolume,
      'activeDelegates': activeDelegates,
      'liquidityRate': liquidityRate,
      'marketIndex': marketIndex,
      'trendPoints': trendPoints,
    };
  }
}
