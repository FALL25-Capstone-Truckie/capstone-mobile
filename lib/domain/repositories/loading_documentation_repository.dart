import 'package:dartz/dartz.dart';
import 'dart:io';

import '../../core/errors/failures.dart';

abstract class LoadingDocumentationRepository {
  /// Document loading and seal - Combined API for packing proof and seal confirmation
  Future<Either<Failure, bool>> documentLoadingAndSeal({
    required String vehicleAssignmentId,
    required String sealCode,
    required List<File> packingProofImages,
    required File sealImage,
  });
}
