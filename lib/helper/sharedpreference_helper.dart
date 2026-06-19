import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _prefs;

  // Keys
  static const String _keyFirstTime = 'firstTime';
  static const String _keyLoginStatus = 'loginStatus';
  static const String _keyName = 'name';
  static const String _keyUserId = 'userid';
  static const String _keyRole = 'role';
  static const String _keyGrade= 'grade';
  static const String _keyAccessToken = 'access_token';
  static const String _keyHasSeenDashboardWalkthrough =
      'hasSeenDashboardWalkthrough';


  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  /// Is First Time Status

    static void setFirstTimeStatus(bool firstStatus) {
    _prefs.setBool(_keyFirstTime, firstStatus);
  }

  static bool getFirstTimeStatus() {
    return _prefs.getBool(_keyFirstTime) ?? true;
  }

  /// Dashboard walkthrough (post-login product tour)
  static void setHasSeenDashboardWalkthrough(bool hasSeen) {
    _prefs.setBool(_keyHasSeenDashboardWalkthrough, hasSeen);
  }

  static bool getHasSeenDashboardWalkthrough() {
    return _prefs.getBool(_keyHasSeenDashboardWalkthrough) ?? false;
  }

  /// Login Status
  static void setLoginStatus(bool loginStatus) {
    _prefs.setBool(_keyLoginStatus, loginStatus);
  }

  static bool getLoginStatus() {
    return _prefs.getBool(_keyLoginStatus) ?? false;
  }

  ///  Name
  static void setName(String name) {
    _prefs.setString(_keyName, name);
  }

  static String getName() {
    return _prefs.getString(_keyName) ?? "";
  }


    ///  Id
  static void setUserId(String userid) {
    _prefs.setString(_keyUserId, userid);
  }

  static String getUserId() {
    return _prefs.getString(_keyUserId) ?? "";
  }


    ///  role
  static void setRole(String role) {
    _prefs.setString(_keyRole, role);
  }

  static String getRole() {
    return _prefs.getString(_keyRole) ?? "";
  }


    ///  grade
  static void setGrade(String grade) {
    _prefs.setString(_keyGrade, grade);
  }

  static String getGrade() {
    return _prefs.getString(_keyGrade) ?? "";
  }



  /// Agent Token
  static void setAccessToken(String accessToken) {
    _prefs.setString(_keyAccessToken, accessToken);
  }

  static String getAccessToken() {
    return _prefs.getString(_keyAccessToken) ?? "";
  }

  /// Clear Specific Preferences
  static void clearAgentToken() {
    _prefs.remove(_keyAccessToken);
  }

  /// Clear All Preferences
  static void clearAllPreferences() {
    _prefs.clear();
  }
}




/* class SharedPreferencesService {
  static late SharedPreferences _prefs;

  static const String _keyLoginStatus= 'loginStatus';
  static const String _keyAgentName = 'agentName';
  static const String _keyAgentEmail = 'agentEmail';
  static const String _keyAgentMobile = 'agentMobile';
  static const String _keyAgentId= 'agentId';
  static const String _keyAgentToken= 'agentToken';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoginStatus(bool loginstatus) async {
    _prefs.setBool(_keyLoginStatus,  loginstatus);
  }

  static Future<bool> getLoginStatus() async {
    return _prefs.getBool(_keyLoginStatus)??false;
  }

  static Future<void> setAgentName(String? agentName) async {
    _prefs.setString(_keyAgentName,  agentName??"");
  }

  static Future<String> getAgentName() async {
    return _prefs.getString(_keyAgentName)??"";
  }




  ///Login Status
  static Future<void> clearAgentToken() async {
    _prefs.remove(_keyAgentToken);
  }

  static Future<void> clearAllPref() async {
    _prefs.clear();
  }
}
 */