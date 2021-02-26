import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';

/// cookie管理器，保证cookieJar的唯一性
/// 默认放在 ApplicationDocumentsDirectory
class CookieUtil {
  /// 非持久cookie
  static final CookieJar cookieJar = new CookieJar();

  /// 持久化cookie
  static PersistCookieJar _pCookieJar;

  static Future<PersistCookieJar> get pCookieJar async {
    if (_pCookieJar == null) {
      _pCookieJar = new PersistCookieJar(
        dir: (await getApplicationDocumentsDirectory()).path,
      );
    }
    return _pCookieJar;
  }
}
