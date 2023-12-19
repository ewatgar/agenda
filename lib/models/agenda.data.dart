// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:agenda/models/contact.data.dart';
import 'package:agenda/models/funciones.dart';
import 'package:flutter/material.dart';

class AgendaData extends ChangeNotifier {
  //CAMPOS---------------------------------------------------------------------
  List<ContactData> contacts;
  bool isSortedAZ;
  List<String> filterLabels;

  //CONSTRUCTORES--------------------------------------------------------------
  AgendaData({List<ContactData>? contacts})
      : contacts = contacts ?? [],
        isSortedAZ = false,
        filterLabels = [];

  factory AgendaData.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> contactsJson = json["contacts"];
    try {
      return AgendaData(
          contacts: contactsJson.map((e) => ContactData.fromJson(e)).toList());
    } on Exception catch (e) {
      print(e);
      return AgendaData();
    }
  }

  //METODOS TO ---------------------------------------------------------------
  @override
  String toString() {
    List<String> contactsString = contacts.map((e) => e.toString()).toList();
    return [...contactsString].join('\n');
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> contactsJson =
        contacts.map((e) => e.toJson()).toList();
    return {
      "contacts": [...contactsJson]
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
    this.notifyListeners();
  }

  //METODOS CREAR/OBTENER JSON ------------------------------------------------

  static String generateJson(AgendaData agenda) {
    return jsonEncode(agenda.toJson());
  }

  static Future<AgendaData?> loadJson({required String path}) async {
    try {
      String filePath = await File(path).readAsString();
      Map<String, dynamic> agendaDataJson = jsonDecode(filePath);
      return AgendaData.fromJson(agendaDataJson);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
