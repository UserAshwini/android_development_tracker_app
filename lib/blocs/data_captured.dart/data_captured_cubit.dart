import 'dart:async';
import 'package:android_development_secquraise/blocs/battery/battery_cubit.dart';
import 'package:android_development_secquraise/blocs/connectivity/connectivity_cubit.dart';
import 'package:android_development_secquraise/blocs/data_captured.dart/data_captured_state.dart';
import 'package:android_development_secquraise/blocs/location/loaction_cubit.dart';
import 'package:android_development_secquraise/blocs/location/location_state.dart';
import 'package:android_development_secquraise/repositories/firebase_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataCaptureCubit extends Cubit<DataCaptureState> {
  Map<String, dynamic> data = {};

  final FirebaseRepository firebaseRepository;
  bool hasUpdatedToFirebaseInSession = true;

  final InternetCubit internetCubit;
  final BatteryCubit batteryCubit;
  final LocationCubit locationCubit;
  int captureCount = 0;
  int frequency = 15; // Default frequency in minutes

  DataCaptureCubit({
    required this.firebaseRepository,
    required this.internetCubit,
    required this.batteryCubit,
    required this.locationCubit,
  }) : super(DataCaptureState(
            internetState: InternetState.initial,
            batteryStatus: BatteryStatus.unknown,
            locationState: LocationLoading(),
            timestamp: DateTime.now(),
            captureCount: 0,
            frequency: 15,
            batteryChargePercentage: 0,
            internetStatus: '',
            batteryStatusText: '',
            locationText: '',
            hasShownLowBatteryAlert: false)) {
    // Listen to changes in Internet, Battery, and Location states
    internetCubit.stream.listen((internetState) {
      updateInternetDataCaptureState(internetState: internetState);
      if (internetCubit.state == InternetState.gained) {
        checkConnectivity();
      }
    });
    batteryCubit.stream.listen((batteryStatus) {
      updateBatteryDataCaptureState(batteryStatus: batteryStatus);
    });
    batteryCubit.getBatteryLevel().then((batteryLevel) {
      updateBatteryDataCaptureState(batteryChargePercentage: batteryLevel);
    });
    batteryCubit.startBatteryMonitoring();

    locationCubit.stream.listen((locationState) {
      if (locationState is LocationLoaded) {
        updateLocationDataCaptureState(locationState: locationState);
      } else if (locationState is LocationPermissionDenied) {}
    });
    locationCubit.startLocationUpdates();

    locationCubit.determinePosition();

    // Start capturing data periodically based on the frequency
    _startDataCaptureTimer();
  }
  Future<void> checkConnectivity() async {
    if (!hasUpdatedToFirebaseInSession) {
      await updateDataToFirebase(data);
      hasUpdatedToFirebaseInSession = true;
    }
  }

  Future<void> updateDataToFirebase(Map<String, dynamic> data) async {
    data = {
      'timestamp': DateTime.now(),
      'captureCount': state.captureCount,
      'frequency': '$frequency',
      'connectivity': '${state.internetStatus}',
      'batteryChargePercentage': '${state.batteryChargePercentage}%',
      'batteryStatusText': ' ${state.batteryStatusText}',
      'locationText': '${state.locationText}',
    };
    await firebaseRepository.updateDataToFirebase(data);
  }

  void updateInternetDataCaptureState({
    InternetState? internetState,
  }) {
    final internetStatus = internetState == InternetState.gained ? 'ON' : 'OFF';
    emit(state.copyWith(
      internetState: internetState ?? state.internetState,
      internetStatus: internetStatus,
    ));
  }

  void updateBatteryDataCaptureState({
    BatteryStatus? batteryStatus,
    int? batteryChargePercentage,
  }) {
    final batteryStatusText =
        batteryStatus == BatteryStatus.charging ? 'ON' : 'OFF';

    emit(state.copyWith(
      batteryStatus: batteryStatus ?? state.batteryStatus,
      batteryChargePercentage:
          batteryChargePercentage ?? state.batteryChargePercentage,
      batteryStatusText: batteryStatusText,
    ));
  }

  void updateLocationDataCaptureState({
    LocationState? locationState,
  }) {
    String locationText = state.locationText;
    if (locationState is LocationLoaded) {
      final position = locationState.position;
      final latitude = position.latitude.toDouble();
      final longitude = position.longitude.toDouble();
      locationText = '$latitude,$longitude';
    } else if (locationState is LocationLoading) {
      locationText = 'Loading location...';
    } else {
      locationText = 'Location data not available';
    }

    emit(state.copyWith(
      locationState: locationState ?? state.locationState,
      locationText: locationText,
    ));
  }

  void updateDataCaptureState() {
    emit(state.copyWith(
      timestamp: DateTime.now(),
      captureCount: state.captureCount + 1,
    ));
  }

  void markLowBatteryAlertShown() {
    emit(state.copyWith(hasShownLowBatteryAlert: true));
  }

  void _startDataCaptureTimer() {
    updateDataCaptureState();
    updateInternetDataCaptureState();
    updateLocationDataCaptureState();
    updateBatteryDataCaptureState();

    Timer.periodic(Duration(minutes: frequency), (_) async {
      if (internetCubit.state == InternetState.gained) {
        try {
          await updateDataToFirebase(data);

          print("CAPTURE COUNT ${state.captureCount}");
        } catch (e) {
          // Handle Firebase update error
          print("Firebase update error: $e");
        }
      } else {
        hasUpdatedToFirebaseInSession = false;
      }
      updateDataCaptureState();
    });
  }
}
