part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;

  static const WEATHER = _Paths.WEATHER;

  static const CITY_SELECTOR = _Paths.CITY_SELECTOR;

  static const CITY_LIST = _Paths.CITY_LIST;

  static const ALERT_DETAIL = _Paths.ALERT_DETAIL;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = '/splash';

  static const WEATHER = '/weather';

  static const CITY_SELECTOR = '/city_selector';

  static const CITY_LIST = '/city_list';

  static const ALERT_DETAIL = '/alert_detail';
}
