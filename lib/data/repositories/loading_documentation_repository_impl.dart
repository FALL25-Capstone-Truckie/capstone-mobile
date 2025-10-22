import 'dart:io';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/loading_documentation_repository.dart';
import '../datasources/api_client.dart';

class LoadingDocumentationRepositoryImpl
    implements LoadingDocumentationRepository {
  final ApiClient _apiClient;

  LoadingDocumentationRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Either<Failure, bool>> documentLoadingAndSeal({
    required String vehicleAssignmentId,
    required String sealCode,
    required List<File> packingProofImages,
    required File sealImage,
  }) async {
    try {
      // Create FormData
      final formData = FormData();

      // Add request fields separately (for @ModelAttribute binding)
      formData.fields.add(MapEntry('vehicleAssignmentId', vehicleAssignmentId));
      formData.fields.add(MapEntry('sealCode', sealCode));

      // Debug log
      debugPrint('========== LOADING DOCUMENTATION REQUEST DEBUG INFO ==========');
      debugPrint('vehicleAssignmentId: $vehicleAssignmentId');
      debugPrint('sealCode: $sealCode');
      debugPrint('packingProofImages count: ${packingProofImages.length}');
      debugPrint('sealImage path: ${sealImage.path}');

      // Add packing proof images
      for (int i = 0; i < packingProofImages.length; i++) {
        final file = packingProofImages[i];
        debugPrint('packingProofImage[$i] path: ${file.path}');
        debugPrint('packingProofImage[$i] exists: ${file.existsSync()}');
        debugPrint('packingProofImage[$i] size: ${file.lengthSync()} bytes');

        formData.files.add(
          MapEntry(
            'packingProofImages',
            await MultipartFile.fromFile(
              file.path,
              filename: 'packing_proof_$i.jpg',
            ),
          ),
        );
      }

      // Add seal image
      debugPrint('sealImage exists: ${sealImage.existsSync()}');
      debugPrint('sealImage size: ${sealImage.lengthSync()} bytes');
      formData.files.add(
        MapEntry(
          'sealImage',
          await MultipartFile.fromFile(
            sealImage.path,
            filename: 'seal_image.jpg',
          ),
        ),
      );

      // Log API endpoint
      debugPrint(
        'API Endpoint: ${_apiClient.dio.options.baseUrl}/loading-documentation/document-loading-and-seal',
      );
      debugPrint('========== END REQUEST DEBUG INFO ==========');

      // Call API
      final response = await _apiClient.dio.post(
        '/loading-documentation/document-loading-and-seal',
        data: formData,
      );

      debugPrint('========== RESPONSE DEBUG INFO ==========');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');
      debugPrint('========== END RESPONSE DEBUG INFO ==========');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return const Right(true);
        } else {
          return Left(
            ServerFailure(
              message: responseData['message'] ?? 'Lỗi khi gửi tài liệu đóng gói và seal',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: 'Lỗi khi gửi tài liệu đóng gói và seal: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint('========== ERROR DEBUG INFO ==========');
      debugPrint('DioException: ${e.message}');
      debugPrint('DioException type: ${e.type}');
      debugPrint('DioException response status: ${e.response?.statusCode}');
      debugPrint('DioException response data: ${e.response?.data}');
      debugPrint('========== END ERROR DEBUG INFO ==========');
      return Left(
        ServerFailure(message: e.message ?? 'Lỗi kết nối đến máy chủ'),
      );
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
