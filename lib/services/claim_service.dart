import 'package:dio/dio.dart';
import 'package:learning_android_1/models/api_response.dart';
import 'package:learning_android_1/models/claim_interface.dart';
import 'package:learning_android_1/services/dio_client.dart';

class ClaimService {
  final _dio = DioClient.instance.dio;
  final String _claimsEndpoint = '/claims';
  final String _claimEndpoint = '/claim';

  Future<ApiResponse<PagingResponse<GetClaimResponse>>> getClaimPaging({
    int pageNum = 1,
    int pageSize = 15,
    String? status,
    String? viewMode,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _dio.get(
        _claimsEndpoint,
        queryParameters: {
          'claimStatus': status,
          'viewMode': viewMode,
          'pageNumber': pageNum,
          'pageSize': pageSize,
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => PagingResponse.fromJson(
          json,
          (json) => GetClaimResponse.fromJson(json),
        ),
      );
      return apiResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data, (json) => null);
      }
      throw Exception('Failed to fetch claims: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<ClaimDetailResponse>> getClaimById({
    required String id,
  }) async {
    try {
      final response = await _dio.get('$_claimEndpoint/$id');
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => ClaimDetailResponse.fromJson(json),
      );
      return apiResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data, (json) => null);
      }
      throw Exception('Failed to fetch claims: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
