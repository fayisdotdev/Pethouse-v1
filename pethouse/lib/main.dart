import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/adoption_provider.dart';
import 'screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCy8jXQLucYrOq7xzxmB7KY8HXyLuk4kL0",
        authDomain: "pethouse-v1.firebaseapp.com",
        projectId: "pethouse-v1",
        storageBucket: "pethouse-v1.firebasestorage.app",
        messagingSenderId: "194118551352",
        appId: "1:194118551352:web:1ae7e9db876053af63a3cd",
        measurementId: "G-DB2EEGB5T5",
      ),
    );
  } catch (e) {
    // Firebase already initialized, ignore the error
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AdoptionProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetHouse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}
