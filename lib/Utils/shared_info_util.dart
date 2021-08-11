import 'package:geolocator/geolocator.dart';
import 'package:prixz_test/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedInfo{

  SharedPreferences sharedPreferences;

// save info logged in to shared preferences
  Future<void> sharedLocationSave(Position location) async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(SHARED_LOCATION_LATITUDE, location.latitude);
    sharedPreferences.setDouble(SHARED_LOCATION_LONGITUDE, location.longitude);
  }

  Future<Position> getLastLocationSaved() async{
    sharedPreferences = await SharedPreferences.getInstance();
    double lat = sharedPreferences.getDouble(SHARED_LOCATION_LATITUDE) ?? 0.0;
    double lng = sharedPreferences.getDouble(SHARED_LOCATION_LONGITUDE) ?? 0.0;
    Position position = Position(latitude: lat, longitude: lng);
    return position;
  }
}