import 'dart:math';

class GpsUtil {
  static const num pi = 3.1415926535897932384626;
  static const num x_pi = 3.14159265358979324 * 3000.0 / 180.0;
  static const num a = 6378245.0;
  static const num ee = 0.00669342162296594323;

  static num transformLat(num x, num y) {
    num ret = -100.0 +
        2.0 * x +
        3.0 * y +
        0.2 * y * y +
        0.1 * x * y +
        0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static num transformLon(num x, num y) {
    num ret =
        300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret +=
        (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
  }

  static List<num> transform(num lat, num lon) {
    if (outOfChina(lat, lon)) {
      return [lat, lon];
    }
    num dLat = transformLat(lon - 105.0, lat - 35.0);
    num dLon = transformLon(lon - 105.0, lat - 35.0);
    num radLat = lat / 180.0 * pi;
    num magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    num sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    num mgLat = lat + dLat;
    num mgLon = lon + dLon;
    return [mgLat, mgLon];
  }

  static bool outOfChina(num lat, num lon) {
    if (lon < 72.004 || lon > 137.8347) return true;
    if (lat < 0.8293 || lat > 55.8271) return true;
    return false;
  }

  /**
   * 84 to 火星坐标系 (GCJ-02) World Geodetic System ==> Mars Geodetic System
   *
   * @param lat
   * @param lon
   * @return
   */
  static List<num> gps84_To_Gcj02(num lat, num lon) {
    if (outOfChina(lat, lon)) {
      return [lat, lon];
    }
    num dLat = transformLat(lon - 105.0, lat - 35.0);
    num dLon = transformLon(lon - 105.0, lat - 35.0);
    num radLat = lat / 180.0 * pi;
    num magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    num sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    num mgLat = lat + dLat;
    num mgLon = lon + dLon;
    return [mgLat, mgLon];
  }

  /**
   * * 火星坐标系 (GCJ-02) to 84 * * @param lon * @param lat * @return
   */
  static List<num> gcj02_To_Gps84(num lat, num lon) {
    List<num> gps = transform(lat, lon);
    num lontitude = lon * 2 - gps[1];
    num latitude = lat * 2 - gps[0];
    return [latitude, lontitude];
  }

  /**
   * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 将 GCJ-02 坐标转换成 BD-09 坐标
   *
   * @param lat
   * @param lon
   */
  static List<num> gcj02_To_Bd09(num lat, num lon) {
    num x = lon, y = lat;
    num z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    num theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    num tempLon = z * cos(theta) + 0.0065;
    num tempLat = z * sin(theta) + 0.006;
    List<num> gps = [tempLat, tempLon];
    return gps;
  }

  /**
   * * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 * * 将 BD-09 坐标转换成GCJ-02 坐标
   * @param lat
   * @param lon
   * @return
   */
  static List<num> bd09_To_Gcj02(num lat, num lon) {
    num x = lon - 0.0065, y = lat - 0.006;
    num z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    num theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    num tempLon = z * cos(theta);
    num tempLat = z * sin(theta);
    List<num> gps = [tempLat, tempLon];
    return gps;
  }

  /**
   * 将gps84转为bd09
   *
   * @param lat
   * @param lon
   * @return
   */
  static List<num> gps84_To_bd09(num lat, num lon) {
    List<num> gcj02 = gps84_To_Gcj02(lat, lon);
    List<num> bd09 = gcj02_To_Bd09(gcj02[0], gcj02[1]);
    return bd09;
  }

  static List<num> bd09_To_gps84(num lat, num lon) {
    List<num> gcj02 = bd09_To_Gcj02(lat, lon);
    List<num> gps84 = gcj02_To_Gps84(gcj02[0], gcj02[1]);
    //保留小数点后六位
    gps84[0] = retain6(gps84[0]);
    gps84[1] = retain6(gps84[1]);
    return gps84;
  }

  /**
   * 保留小数点后六位
   *
   * @param num
   * @return
   */
  static num retain6(num n) {
    return num.parse(n.toStringAsFixed(6));
  }
}