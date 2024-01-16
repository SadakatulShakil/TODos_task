import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_dos/Provider/provider_service.dart';
import 'package:to_dos/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyCMzComVWU5plAj2FxxMBB5Wo1k2pix_AU',
        appId: '1:78221884421:android:d9b4b0d0764a8bf10df06c',
        messagingSenderId: '78221884421',
        projectId: 'todos-fa13a')
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.green
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
