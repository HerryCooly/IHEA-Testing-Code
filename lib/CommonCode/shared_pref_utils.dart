import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  /// --------------------------------------------------------------------------
  /// Helper method to get the draft count from shared preferences stored on the device
  /// --------------------------------------------------------------------------
  static Future<int> getDraftCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var draftCount = prefs.getInt('draftCount');
    return draftCount ?? 0;
  }

  /// --------------------------------------------------------------------------
  /// Helper method to increment the draft count in device preferences
  /// --------------------------------------------------------------------------
  static Future<void> incrementDraftCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final draftCount = await getDraftCount();
    await prefs.setInt('draftCount', draftCount + 1);
  }

  /// --------------------------------------------------------------------------
  /// Helper method to decrement the draft count in device preferences
  /// --------------------------------------------------------------------------
  static Future<void> decrementDraftCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final draftCount = await getDraftCount();
    if (draftCount > 0) {
      await prefs.setInt('draftCount', draftCount - 1);
    }
  }
}
