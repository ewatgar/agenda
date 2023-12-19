// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:agenda/models/agenda.data.dart';
import 'package:agenda/pages/loading.page.dart';
import 'package:flutter/material.dart';
import 'package:agenda/pages/contacts.page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<AgendaData> _agenda;
  late ThemeData _themeTemplate;
  late ThemeData _theme;

  @override
  void initState() {
    _agenda = AgendaData.load(false);
    _themeTemplate = ThemeData.dark(useMaterial3: false);
    _theme = _themeTemplate.copyWith(
        progressIndicatorTheme: ProgressIndicatorThemeData(
            circularTrackColor: _themeTemplate.indicatorColor),
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: _themeTemplate.indicatorColor),
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            floatingLabelStyle: TextStyle(color: _themeTemplate.indicatorColor),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _themeTemplate.indicatorColor))),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: _themeTemplate.indicatorColor,
              side:
                  BorderSide(color: _themeTemplate.indicatorColor, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(color: Colors.transparent),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal, background: Colors.black));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AgendaData>(
        future: _agenda,
        builder: (context, AsyncSnapshot<AgendaData> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return makeMaterialApp(LoadingPage());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return makeMaterialApp(
                    Center(child: Text('Error: ${snapshot.error}')));
              } else {
                return ChangeNotifierProvider.value(
                  value: snapshot.data,
                  child: makeMaterialApp(ContactsPage()),
                );
              }
          }
        });
  }

  MaterialApp makeMaterialApp([Widget? child]) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      theme: _theme,
      home: child,
    );
  }
}
