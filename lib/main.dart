// @dart=2.9
import 'package:flutter/material.dart';
import 'package:ssia_app/infrastructure/factories/db_factory.dart';
import 'package:ssia_app/ui_composer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseFactory().createDatabase();
  UiComposer.configure(db);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSIA',
      debugShowCheckedModeBanner: false,
      home: UiComposer.composeHomePage(),
    );
  }
}
