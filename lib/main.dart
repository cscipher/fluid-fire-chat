import 'package:chat_room_demo/firebase_options.dart';
import 'package:chat_room_demo/src/screens/lobby_screen.dart';
import 'package:chat_room_demo/utils/theme_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Room Demo',
      /// this current theme notifier is used to update the theme accent from the app
      theme: currentTheme.colorSchemeBasedTheme,
      home: const LobbyScreen(),
    );
  }
}
