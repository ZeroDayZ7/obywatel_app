enum VotingCategory {
  all,
  forYou,
  local,
  regional,
  national,
  laws,
  resolutions,
  budgets,
  myVotes,
  myDelegations,
  closed,
}

enum VotingSort {
  endingSoonest,
  mostPopular,
  newest,
  requiresMyVote,
}

enum VoteChoice { yes, no, abstain }

enum VotingScope { local, regional, national }

enum DelegationScope {
  all,
  local,
  regional,
  national,
  category,
  temporary,
}

extension VotingCategoryX on VotingCategory {
  String get label {
    switch (this) {
      case VotingCategory.all:
        return 'Wszystkie';
      case VotingCategory.forYou:
        return 'Dla Ciebie';
      case VotingCategory.local:
        return 'Lokalne';
      case VotingCategory.regional:
        return 'Regionalne';
      case VotingCategory.national:
        return 'Krajowe';
      case VotingCategory.laws:
        return 'Ustawy';
      case VotingCategory.resolutions:
        return 'Uchwały';
      case VotingCategory.budgets:
        return 'Budżety';
      case VotingCategory.myVotes:
        return 'Moje głosowania';
      case VotingCategory.myDelegations:
        return 'Moje delegacje';
      case VotingCategory.closed:
        return 'Zakończone';
    }
  }
}

extension VotingSortX on VotingSort {
  String get label {
    switch (this) {
      case VotingSort.endingSoonest:
        return 'Kończące się najwcześniej';
      case VotingSort.mostPopular:
        return 'Najpopularniejsze';
      case VotingSort.newest:
        return 'Najnowsze';
      case VotingSort.requiresMyVote:
        return 'Wymagające mojego głosu';
    }
  }
}

extension VoteChoiceX on VoteChoice {
  String get label {
    switch (this) {
      case VoteChoice.yes:
        return 'ZA';
      case VoteChoice.no:
        return 'PRZECIW';
      case VoteChoice.abstain:
        return 'WSTRZYMUJĘ SIĘ';
    }
  }
}

class CitizenProfile {
  const CitizenProfile({
    required this.id,
    required this.fullName,
    required this.location,
    required this.avatarUrl,
    required this.votesCount,
    required this.participationRate,
    required this.delegatingCount,
    required this.votingPower,
    required this.interests,
    required this.votingHistory,
    required this.isCurrentUser,
  });

  final String id;
  final String fullName;
  final String location;
  final String avatarUrl;
  final int votesCount;
  final int participationRate;
  final int delegatingCount;
  final double votingPower;
  final List<String> interests;
  final List<CitizenVoteHistory> votingHistory;
  final bool isCurrentUser;
}

class CitizenVoteHistory {
  const CitizenVoteHistory({
    required this.votingId,
    required this.title,
    required this.choice,
    required this.category,
    required this.date,
  });

  final String votingId;
  final String title;
  final VoteChoice choice;
  final String category;
  final DateTime date;
}

class VotingArgument {
  const VotingArgument({
    required this.author,
    required this.text,
    required this.supporters,
    required this.isKey,
  });

  final String author;
  final String text;
  final int supporters;
  final bool isKey;
}

class CommentItem {
  const CommentItem({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.likes,
    required this.replies,
    this.createdAt,
    required this.category,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String text;
  final int likes;
  final int replies;
  final DateTime? createdAt;
  final String category;
}

class Delegation {
  const Delegation({
    required this.id,
    required this.sourceCitizenId,
    required this.sourceName,
    required this.targetCitizenId,
    required this.targetName,
    required this.scope,
    required this.category,
    required this.note,
    required this.isActive,
  });

  final String id;
  final String sourceCitizenId;
  final String sourceName;
  final String targetCitizenId;
  final String targetName;
  final DelegationScope scope;
  final String category;
  final String note;
  final bool isActive;
}

class Voting {
  const Voting({
    required this.id,
    required this.title,
    required this.type,
    required this.scope,
    required this.category,
    required this.status,
    required this.initiator,
    required this.summary,
    required this.justification,
    required this.keyChanges,
    required this.impact,
    required this.costs,
    required this.sourceDocument,
    required this.history,
    required this.participantCount,
    required this.turnout,
    required this.endsAt,
    required this.userHasVoted,
    required this.userChoice,
    required this.userDelegated,
    required this.delegatedTo,
    required this.argumentsFor,
    required this.argumentsAgainst,
    required this.comments,
    required this.tags,
  });

  final String id;
  final String title;
  final String type;
  final VotingScope scope;
  final VotingCategory category;
  final String status;
  final String initiator;
  final String summary;
  final String justification;
  final List<String> keyChanges;
  final List<String> impact;
  final List<String> costs;
  final String sourceDocument;
  final List<String> history;
  final int participantCount;
  final double turnout;
  final DateTime endsAt;
  final bool userHasVoted;
  final VoteChoice? userChoice;
  final bool userDelegated;
  final String? delegatedTo;
  final List<VotingArgument> argumentsFor;
  final List<VotingArgument> argumentsAgainst;
  final List<CommentItem> comments;
  final List<String> tags;
}

class DashboardStats {
  const DashboardStats({
    required this.activeVotingCount,
    required this.votedCount,
    required this.delegationsCount,
    required this.currentVotingPower,
  });

  final int activeVotingCount;
  final int votedCount;
  final int delegationsCount;
  final double currentVotingPower;
}
