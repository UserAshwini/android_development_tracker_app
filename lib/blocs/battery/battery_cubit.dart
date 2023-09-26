import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BatteryStatus { charging, notCharging, unknown }

class BatteryCubit extends Cubit<BatteryStatus> {
  final Battery _battery = Battery();

  BatteryCubit() : super(BatteryStatus.unknown);

  Future<int> getBatteryLevel() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      print("Battery Level: $batteryLevel");

      return batteryLevel;
    } catch (e) {
      print("Battery Error: $e");

      emit(BatteryStatus.unknown);
      return -1;
    }
  }

  void startBatteryMonitoring() {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (state == BatteryState.charging) {
        print("Battery Charging");
        emit(BatteryStatus.charging);
      } else if (state == BatteryState.discharging) {
        print("Battery Discharging");
        emit(BatteryStatus.notCharging);
      } else {
        print("Battery Unknown");
        emit(BatteryStatus.unknown);
      }
    });
  }
}
