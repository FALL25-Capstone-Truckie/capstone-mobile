import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/issue.dart';
import '../../repositories/issue_repository.dart';

/// UseCase để driver xác nhận đã gắn seal mới
class ConfirmSealReplacementUseCase {
  final IssueRepository repository;

  ConfirmSealReplacementUseCase(this.repository);

  Future<Either<Failure, Issue>> call(ConfirmSealReplacementParams params) async {
    try {
      final result = await repository.confirmSealReplacement(
        issueId: params.issueId,
        newSealAttachedImage: params.newSealAttachedImage,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to confirm seal replacement: $e'));
    }
  }
}

class ConfirmSealReplacementParams {
  final String issueId;
  final String newSealAttachedImage;

  const ConfirmSealReplacementParams({
    required this.issueId,
    required this.newSealAttachedImage,
  });
}
