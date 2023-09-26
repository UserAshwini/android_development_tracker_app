import 'package:android_development_secquraise/blocs/battery/battery_cubit.dart';
import 'package:android_development_secquraise/blocs/connectivity/connectivity_cubit.dart';
import 'package:android_development_secquraise/blocs/data_captured.dart/data_captured_cubit.dart';
import 'package:android_development_secquraise/blocs/location/loaction_cubit.dart';
import 'package:android_development_secquraise/firebase_options.dart';
import 'package:android_development_secquraise/repositories/firebase_repository.dart';
import 'package:android_development_secquraise/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseRepository = FirebaseRepository();
  runApp( MyApp(firebaseRepository: firebaseRepository,));
}

class MyApp extends StatelessWidget {
  final FirebaseRepository firebaseRepository;
    const MyApp({super.key,required this.firebaseRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: BlocProvider(
          create: (context) => DataCaptureCubit(
              internetCubit: InternetCubit(),
              batteryCubit: BatteryCubit(),
              locationCubit: LocationCubit(), firebaseRepository: firebaseRepository),
          child: const HomeScreen()),
    );
  }
}
