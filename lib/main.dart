import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_bloc/UI/google_map.dart';
import 'BLoc/Marker/marker_bloc.dart';
import 'Services/hive_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  try {
    await Hive.initFlutter();
    // Hive will automatically register the adapter when we run build_runner
    await HiveService.init();
    
    runApp(const MyApp());
  } catch (e) {
    print('Failed to initialize Hive: $e');
    // Handle the error appropriately
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MarkerBloc()),
      ],
      child: MaterialApp(
        title: 'BLoC Marker Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: GoogleMapScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
