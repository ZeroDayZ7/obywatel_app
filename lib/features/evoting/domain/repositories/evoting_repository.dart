import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';

abstract class EVotingRepository {
  Future<List<Voting>> getVotings({
    VotingCategory category = VotingCategory.all,
    VotingSort sort = VotingSort.endingSoonest,
  });

  Future<Voting?> getVotingById(String id);
  Future<CitizenProfile?> getCitizenById(String citizenId);
  Future<List<CitizenProfile>> getCitizenProfiles();
  Future<List<Delegation>> getDelegations();
  Future<List<CommentItem>> getComments(String votingId);
  Future<void> castVote(String votingId, VoteChoice choice, {bool delegated = false});
  Future<void> delegateVote({
    required String sourceCitizenId,
    required String targetCitizenId,
    required DelegationScope scope,
    required String category,
    required String note,
    bool isActive = true,
  });
  Future<void> removeDelegation(String sourceCitizenId, String targetCitizenId);
  Future<List<Voting>> getMyVotes();
  Future<DashboardStats> getDashboardStats();
}
