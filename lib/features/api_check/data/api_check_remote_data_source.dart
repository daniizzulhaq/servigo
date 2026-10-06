import 'package:dio/dio.dart';
import 'package:servigo/core/constants/api_constants.dart';

/// Satu-satunya kelas di fitur ini yang memanggil Dio.
/// Tugasnya hanya mengirim request dan mengembalikan respons mentah.
class ApiCheckRemoteDataSource {
  const ApiCheckRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> ping() {
    return _dio.get<dynamic>(ApiConstants.pingPath);
  }
}