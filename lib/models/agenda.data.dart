// ignore_for_file: avoid_print

import 'package:agenda/models/contact.data.dart';
import 'package:flutter/material.dart';

class AgendaData extends ChangeNotifier {
  //CAMPOS---------------------------------------------------------------------
  List<ContactData> contacts;

  //CONSTRUCTORES--------------------------------------------------------------
  AgendaData({this.contacts = const []});

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
}
