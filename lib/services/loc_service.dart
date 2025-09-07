import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';

class LocationStorageService {
  static const String _locationLatKey = 'selected_location_lat';
  static const String _locationLngKey = 'selected_location_lng';
  static const String _locationAddressKey = 'selected_location_address';

  // Simpan lokasi ke local storage
  static Future<void> saveLocation(LatLng location, String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_locationLatKey, location.latitude);
    await prefs.setDouble(_locationLngKey, location.longitude);
    await prefs.setString(_locationAddressKey, address);
  }

  // Load lokasi dari local storage
  static Future<Map<String, dynamic>?> loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? lat = prefs.getDouble(_locationLatKey);
    final double? lng = prefs.getDouble(_locationLngKey);
    final String? address = prefs.getString(_locationAddressKey);

    if (lat != null && lng != null) {
      return {
        'location': LatLng(lat, lng),
        'address': address ?? 'Lokasi tersimpan'
      };
    }
    return null;
  }

  // Hapus lokasi dari local storage
  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationLatKey);
    await prefs.remove(_locationLngKey);
    await prefs.remove(_locationAddressKey);
  }

  // Cek apakah ada lokasi yang tersimpan
  static Future<bool> hasSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_locationLatKey) && 
           prefs.containsKey(_locationLngKey);
  }
}