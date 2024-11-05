import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instaclone/pages/home.dart';
import 'package:instaclone/pages/loginpage.dart';
import 'package:instaclone/serices/firebaseserice.dart';

const firebaseConfig = {};

var options = FirebaseOptions(
    apiKey: "AIzaSyAlkAD2OMy0zuzkJAYIeDrP-SqdXmaz8fg",
    authDomain: "finstagram-d8ebf.firebaseapp.com",
    projectId: "finstagram-d8ebf",
    storageBucket: "finstagram-d8ebf.appspot.com",
    messagingSenderId: "222233995854",
    appId: "1:222233995854:web:e8389297ffe883c595311f",
    measurementId: "G-H38594MSLC");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GetIt.instance.registerSingleton<FirebaseSerice>(
    FirebaseSerice(),
  );

  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const MyApp(),
      'home': (context) => const Home(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}
