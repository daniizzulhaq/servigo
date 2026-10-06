import 'package:servigo/core/network/api_call.dart';
import 'package:servigo/features/api_check/data/api_check_remote_data_source.dart';
import 'package:servigo/features/api_check/models/api_check_result.dart';

/// Perantara antara provider (UI) dan data source (API).
/// Tugas: mengubah respons mentah menjadi model, dan error Dio menjadi
/// ApiException.
class ApiCheckRepository {
  const ApiCheckRepository(this._dataSource);

  final ApiCheckRemoteDataSource _dataSource;

  Future<ApiCheckResult> ping() {
    return safeApiCall(() async {
      final response = await _dataSource.ping();

      return ApiCheckResult(
        statusCode: response.statusCode ?? 0,
        summary: _summarize(response.data),
      );
    });
  }

  String _summarize(Object? data) {
    if (data is Map) {
      final message = data['message'];
      if (message is String) return message;

      final keys = data.keys.take(5).join(', ');
      return 'JSON dengan ${data.length} field: $keys';
    }
    return 'Respons diterima (${data.runtimeType})';
  }
}