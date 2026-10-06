class DelegationOffer {
  const DelegationOffer({
    required this.id,
    required this.delegateName,
    required this.avatarLabel,
    required this.category,
    required this.votingPower,
    required this.reputation,
    required this.historicalYield,
    required this.fee,
    required this.strategyDescription,
    required this.liquidityStatus,
    this.badge = '',
    this.activeProposals = const [],
    this.isVerified = false,
  });

  final String id;
  final String delegateName;
  final String avatarLabel;
  final String category;
  final int votingPower;
  final double reputation;
  final double historicalYield;
  final double fee;
  final String strategyDescription;
  final String liquidityStatus;
  final String badge;
  final List<String> activeProposals;
  final bool isVerified;

  DelegationOffer copyWith({
    String? id,
    String? delegateName,
    String? avatarLabel,
    String? category,
    int? votingPower,
    double? reputation,
    double? historicalYield,
    double? fee,
    String? strategyDescription,
    String? liquidityStatus,
    String? badge,
    List<String>? activeProposals,
    bool? isVerified,
  }) {
    return DelegationOffer(
      id: id ?? this.id,
      delegateName: delegateName ?? this.delegateName,
      avatarLabel: avatarLabel ?? this.avatarLabel,
      category: category ?? this.category,
      votingPower: votingPower ?? this.votingPower,
      reputation: reputation ?? this.reputation,
      historicalYield: historicalYield ?? this.historicalYield,
      fee: fee ?? this.fee,
      strategyDescription: strategyDescription ?? this.strategyDescription,
      liquidityStatus: liquidityStatus ?? this.liquidityStatus,
      badge: badge ?? this.badge,
      activeProposals: activeProposals ?? this.activeProposals,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  factory DelegationOffer.fromJson(Map<String, dynamic> json) {
    return DelegationOffer(
      id: json['id'] as String? ?? '',
      delegateName: json['delegateName'] as String? ?? '',
      avatarLabel: json['avatarLabel'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      votingPower: (json['votingPower'] as num?)?.toInt() ?? 0,
      reputation: (json['reputation'] as num?)?.toDouble() ?? 0,
      historicalYield: (json['historicalYield'] as num?)?.toDouble() ?? 0,
      fee: (json['fee'] as num?)?.toDouble() ?? 0,
      strategyDescription: json['strategyDescription'] as String? ?? '',
      liquidityStatus: json['liquidityStatus'] as String? ?? 'Aktywny',
      badge: json['badge'] as String? ?? '',
      activeProposals: (json['activeProposals'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delegateName': delegateName,
      'avatarLabel': avatarLabel,
      'category': category,
      'votingPower': votingPower,
      'reputation': reputation,
      'historicalYield': historicalYield,
      'fee': fee,
      'strategyDescription': strategyDescription,
      'liquidityStatus': liquidityStatus,
      'badge': badge,
      'activeProposals': activeProposals,
      'isVerified': isVerified,
    };
  }
}
