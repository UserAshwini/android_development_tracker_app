import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final Position position;

  const LocationLoaded(this.position);

 
}

class LocationPermissionDenied extends LocationState{
  final String errorMessage;
  const LocationPermissionDenied(this.errorMessage);
}