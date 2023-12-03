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
    AgendaData agenda = AgendaData.fromJson(agendaJson);

    ThemeData theme = ThemeData.dark(useMaterial3: false);

    return ChangeNotifierProvider<AgendaData>(
      create: (_) => agenda,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agenda',
        theme: theme.copyWith(
            listTileTheme: const ListTileThemeData(
              iconColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(color: const Color.fromARGB(0, 0, 0, 0)),
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal, background: Colors.black)),
        home: ContactsPage(),
      ),
    );
  }
}
