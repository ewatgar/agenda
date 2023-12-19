// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:agenda/data/agenda.json.dart';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/models/funciones.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaData extends ChangeNotifier {
  //CAMPOS---------------------------------------------------------------------
  List<ContactData> contacts;
  bool isSortedAZ;
  List<String> filterLabels;

  //CONSTRUCTORES--------------------------------------------------------------
  AgendaData(
      {List<ContactData>? contacts,
      bool? isSortedAZ = false,
      List<String>? filterLabels})
      : contacts = contacts ?? [],
        isSortedAZ = isSortedAZ ?? false,
        filterLabels = filterLabels ?? ["noLabels"];

  factory AgendaData.fromJson(Map<String, dynamic> json) {
    return AgendaData(
        contacts: json["contacts"] != null
            ? List<Map<String, dynamic>>.from(json["contacts"])
                .map<ContactData>((e) => ContactData.fromJson(e))
                .toList()
            : [],
        isSortedAZ: json["isSortedAZ"] ?? false,
        filterLabels: json["filterLabels"] != null
            ? List<String>.from(json["filterLabels"])
            : []);
  }

  //METODOS TO ---------------------------------------------------------------
  @override
  String toString() {
    List<String> contactsString = contacts.map((e) => e.toString()).toList();
    return [...contactsString].join('\n');
  }

  Map<String, dynamic> toJson() {
    return {
      if (contacts.isNotEmpty) "contacts": [...contacts.map((e) => e.toJson())],
      "isSortedAZ": isSortedAZ,
      if (filterLabels.isNotEmpty)
        "filterLabels": filterLabels
      else
        "filterLabels": ["noLabels"]
    };
  }

  //METODOS COPY -------------------------------------------------------------
  AgendaData copyWith({required List<ContactData>? contacts}) {
    return AgendaData(contacts: contacts ?? this.contacts);
  }

  //METODOS ORDENAR ----------------------------------------------------------
  void sortAZ() {
    contacts.sort((a, b) {
      String aFullName = "${a.name} ${a.surname}";
      String bFullName = "${b.name} ${b.surname}";

      return diacriticsCaseAwareCompareTo(
          aFullName.toString(), bFullName.toString());
    });
    isSortedAZ = true;
    notifyListeners();
  }

  void sortZA() {
    contacts.sort((a, b) {
      String aFullName = "${a.name} ${a.surname}";
      String bFullName = "${b.name} ${b.surname}";

      return diacriticsCaseAwareCompareTo(
          bFullName.toString(), aFullName.toString());
    });
    isSortedAZ = false;
    notifyListeners();
  }

  //METODOS MISC -------------------------------------------------------------
  void dropContact({required int id}) {
    bool exists = contacts.any((e) => e.id == id);
    if (exists) {
      contacts.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }

  void notifyChanges() {
    notifyListeners();
    save();
  }

  //METODOS PERSISTENCIA -----------------------------------------------------
  Future<void> save() async {
    print("----------------------------------------------> Guardando cambios");
    print(toJson());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("agenda", jsonEncode(toJson()));
  }

  static Future<AgendaData> load([bool bUseDemoData = false]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 2));

    String? agendaJsonStr = prefs.getString("agenda");
    if (agendaJsonStr != null) {
      Map<String, dynamic> agendaJson = jsonDecode(agendaJsonStr);
      print(agendaJson);
      return AgendaData.fromJson(agendaJson);
    } else {
      if (bUseDemoData) {
        return AgendaData.fromJson(agendaDemoJson);
      } else {
        return AgendaData();
      }
    }
  }
}
