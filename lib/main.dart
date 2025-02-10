import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fihmmcsisgoomjzdpnfk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpaG1tY3Npc2dvb21qemRwbmZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3MTM2NjQsImV4cCI6MjA1NDI4OTY2NH0.K92n36h-Nj-92XarTmmqCJ3VJKBIUU_-2cHfsOwVz8w',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPageWidget(),
    );
  }
}
