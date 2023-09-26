import 'package:android_development_secquraise/blocs/battery/battery_cubit.dart';
import 'package:android_development_secquraise/blocs/connectivity/connectivity_cubit.dart';
import 'package:android_development_secquraise/blocs/location/location_state.dart';

class DataCaptureState {
  final InternetState internetState;
  final BatteryStatus batteryStatus;
  final LocationState locationState;
  final DateTime timestamp;
  final int captureCount;
  final int frequency;
  final int batteryChargePercentage;
  final String internetStatus;
  final String batteryStatusText;
  final String locationText;
  final bool hasShownLowBatteryAlert;

  DataCaptureState({
    required this.hasShownLowBatteryAlert,
    required this.internetState,
    required this.batteryStatus,
    required this.batteryChargePercentage,
    required this.locationState,
    required this.timestamp,
    required this.captureCount,
    required this.frequency,
    required this.internetStatus,
    required this.batteryStatusText,
    required this.locationText,
  });

  DataCaptureState copyWith({
    InternetState? internetState,
    BatteryStatus? batteryStatus,
    LocationState? locationState,
    DateTime? timestamp,
    int? captureCount,
    int? frequency,
    int? batteryChargePercentage,
    String? internetStatus,
    String? batteryStatusText,
    String? locationText,
    bool? hasShownLowBatteryAlert,
  }) {
    return DataCaptureState(
      internetState: internetState ?? this.internetState,
      batteryStatus: batteryStatus ?? this.batteryStatus,
      locationState: locationState ?? this.locationState,
      timestamp: timestamp ?? this.timestamp,
      captureCount: captureCount ?? this.captureCount,
      frequency: frequency ?? this.frequency,
      batteryChargePercentage:
          batteryChargePercentage ?? this.batteryChargePercentage,
      internetStatus: internetStatus ?? this.internetStatus,
      batteryStatusText: batteryStatusText ?? this.batteryStatusText,
      locationText: locationText ?? this.locationText,
      hasShownLowBatteryAlert:
          hasShownLowBatteryAlert ?? this.hasShownLowBatteryAlert,
    );
  }
}
