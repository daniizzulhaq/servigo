/// Daftar path dan nama rute aplikasi.
///
/// - `xxxPath` : alamat rute (dipakai di definisi GoRouter)
/// - `xxx`     : nama rute (dipakai saat navigasi: context.pushNamed(...))
class AppRoutes {
  AppRoutes._();

  // Path
  static const String splashPath = '/splash';
  static const String welcomePath = '/';
  static const String themePreviewPath = '/theme-preview';
  static const String serviceDetailPath = '/services/:id';
  static const String apiCheckPath = '/api-check';

  // Name
  static const String splash = 'splash';
  static const String welcome = 'welcome';
  static const String themePreview = 'theme-preview';
  static const String serviceDetail = 'service-detail';
  static const String apiCheck = 'api-check';
}