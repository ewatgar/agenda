// ignore_for_file: prefer_const_constructors

import 'package:agenda/data/agenda.json.dart';
import 'package:agenda/models/agenda.data.dart';
import 'package:flutter/material.dart';
import 'package:agenda/pages/contacts.page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData.dark(useMaterial3: false);

    return ChangeNotifierProvider<AgendaData>(
      create: (_) => AgendaData(), //.fromJson(agendaJson),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agenda',
        //CONFIG ESTILO APP
        theme: theme.copyWith(
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: theme.indicatorColor),
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                floatingLabelStyle: TextStyle(color: theme.indicatorColor),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.indicatorColor))),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  foregroundColor: theme.indicatorColor,
                  side: BorderSide(color: theme.indicatorColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            listTileTheme: ListTileThemeData(
              iconColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(color: Colors.transparent),
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal, background: Colors.black)),
        home: ContactsPage(),
      ),
    );
  }
}
