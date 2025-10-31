import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/loading_documentation_repository.dart';

class DocumentLoadingAndSealUseCase {
  final LoadingDocumentationRepository _repository;

  DocumentLoadingAndSealUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required String vehicleAssignmentId,
    required String sealCode,
    required List<File> packingProofImages,
    required File sealImage,
  }) {
    return _repository.documentLoadingAndSeal(
      vehicleAssignmentId: vehicleAssignmentId,
      sealCode: sealCode,
      packingProofImages: packingProofImages,
      sealImage: sealImage,
    );
  }
}
