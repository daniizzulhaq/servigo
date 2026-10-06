import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servigo/core/network/api_client.dart';
import 'package:servigo/features/api_check/data/api_check_remote_data_source.dart';
import 'package:servigo/features/api_check/models/api_check_result.dart';
import 'package:servigo/features/api_check/repositories/api_check_repository.dart';

// Rantai dependency (dependency injection lewat Riverpod):
// dioProvider → dataSourceProvider → repositoryProvider → notifier

final apiCheckDataSourceProvider = Provider<ApiCheckRemoteDataSource>(
  (ref) => ApiCheckRemoteDataSource(ref.watch(dioProvider)),
);

final apiCheckRepositoryProvider = Provider<ApiCheckRepository>(
  (ref) => ApiCheckRepository(ref.watch(apiCheckDataSourceProvider)),
);

/// State layar cek koneksi.
///
/// AsyncValue punya 3 kondisi: loading, data, error.
/// Nilai `null` pada data berarti "belum pernah dicek".
class ApiCheckNotifier extends Notifier<AsyncValue<ApiCheckResult?>> {
  @override
  AsyncValue<ApiCheckResult?> build() => const AsyncData(null);

  Future<void> check() async {
    state = const AsyncLoading();

    // guard: menjalankan fungsi, lalu otomatis menjadi
    // AsyncData (berhasil) atau AsyncError (melempar exception).
    state = await AsyncValue.guard(
      () => ref.read(apiCheckRepositoryProvider).ping(),
    );
  }
}

final apiCheckProvider =
    NotifierProvider<ApiCheckNotifier, AsyncValue<ApiCheckResult?>>(
  ApiCheckNotifier.new,
);