import 'package:android_development_secquraise/blocs/location/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationLoading());

  final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.best,
  distanceFilter: 100,
);


Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: locationSettings.accuracy,);
}



  Future startLocationUpdates() async{
    Geolocator.getPositionStream(
      locationSettings: locationSettings
    ).listen((Position position) {
      emit(LocationLoaded(position));
    });
  }
 
}


