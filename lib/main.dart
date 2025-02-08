import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://fihmmcsisgoomjzdpnfk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpaG1tY3Npc2dvb21qemRwbmZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3MTM2NjQsImV4cCI6MjA1NDI4OTY2NH0.K92n36h-Nj-92XarTmmqCJ3VJKBIUU_-2cHfsOwVz8w',
  );
  runApp(MyApp());
}

class Supabase {
  static initialize({required String url, required String anonKey}) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
    );
  }
}