/// Daftar path dan nama rute aplikasi.
///
/// Dua jenis konstanta dipisah:
/// - `xxxPath` : alamat rute (dipakai di definisi GoRouter)
/// - `xxx`     : nama rute (dipakai saat navigasi: context.pushNamed(...))
///
/// Dengan begini tidak ada string rute yang ditulis manual di widget,
/// sehingga salah ketik bisa ketahuan oleh compiler.
class AppRoutes {
  AppRoutes._();

  // Path
  static const String welcomePath = '/';
  static const String themePreviewPath = '/theme-preview';
  static const String serviceDetailPath = '/services/:id';

  // Name
  static const String welcome = 'welcome';
  static const String themePreview = 'theme-preview';
  static const String serviceDetail = 'service-detail';
}