import 'package:android_development_secquraise/blocs/data_captured.dart/data_captured_cubit.dart';
import 'package:android_development_secquraise/blocs/data_captured.dart/data_captured_state.dart';
import 'package:android_development_secquraise/widgets/custom_button.dart';
import 'package:android_development_secquraise/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 30), () {
      _checkLowBattery(context);
    });
    return SafeArea(child: Scaffold(
      body: BlocBuilder<DataCaptureCubit, DataCaptureState>(
        builder: (context, state) {
          final batteryChargePercentage = state.batteryChargePercentage;
          final timestamp = state.timestamp;
          final captureCount = state.captureCount;
          final frequency = state.frequency;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "assets/image1.png",
                      height: 100,
                      width: 200,
                    )),
              ),
              Center(
                child: Text('$timestamp', style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(
                height: 12,
              ),
              RowTextWidget(
                text1: 'Capture Count',
                text2: '$captureCount',
              ),
              RowTextWidget(
                text1: 'Frequency (min)',
                text2: '$frequency',
              ),
              RowTextWidget(
                  text1: 'Connectivity', text2: '${state.internetStatus}'),
              RowTextWidget(
                  text1: 'Battery Charging',
                  text2: ' ${state.batteryStatusText}'),
              RowTextWidget(
                  text1: 'Battery Charge', text2: '$batteryChargePercentage%'),
              RowTextWidget(text1: 'Location', text2: '${state.locationText}'),
              const SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    onPressed: () async {
                      final data = {
                        'timestamp': DateTime.now(),
                        'captureCount': state.captureCount,
                        'frequency': '$frequency',
                        'connectivity': '${state.internetStatus}',
                        'batteryChargePercentage': '$batteryChargePercentage%',
                        'batteryStatusText': ' ${state.batteryStatusText}',
                        'locationText': '${state.locationText}',
                      };

                      BlocProvider.of<DataCaptureCubit>(context)
                          .updateDataToFirebase(data);
                    },
                    text: "Manual Data Refresh",
                  ))
            ],
          );
        },
      ),
    ));
  }

  void _checkLowBattery(BuildContext context) {
    final batteryChargePercentage = BlocProvider.of<DataCaptureCubit>(context)
        .state
        .batteryChargePercentage;

    if (batteryChargePercentage <= 20) {
      _showLowBatteryAlert(context);
    }
  }

  void _showLowBatteryAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Low Battery'),
          content: const Text(
              'Your battery level is less than 20%. Please charge your device.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
