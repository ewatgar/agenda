import 'package:flutter/material.dart';

class ContactData extends ChangeNotifier {
  //CAMPOS---------------------------------------------------------------------
  int id;
  String? name;
  String? surname;
  String? email;
  String? phone;
  DateTime? birthdate;
  DateTime? creation;
  DateTime? modification;
  bool isFavorite;
  List<String>? labels;

  //CONSTRUCTORES--------------------------------------------------------------
  ContactData({
    this.id = -1,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.birthdate,
    this.creation,
    this.modification,
    this.isFavorite = false,
    this.labels,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        phone: json["phone"],
        birthdate: DateTime.tryParse(json["birthdate"] ?? ""),
        creation: DateTime.tryParse(json["creation"] ?? ""),
        modification: DateTime.tryParse(json["modification"] ?? ""),
        isFavorite: json["isFavorite"],
        labels: json["labels"]);
  }

  //METODOS to ---------------------------------------------------------------
  @override
  String toString() {
    return [
      'CONTACTO (',
      '\tId: $id',
      if (name != null) '\tNombre: $name',
      if (surname != null) '\tApellido: $surname',
      if (email != null) '\tEmail: $email',
      if (phone != null) '\tTelefono: $phone',
      if (birthdate != null) '\tFecha de nacimiento: $birthdate',
      if (creation != null) '\tFecha de creación: $creation',
      if (modification != null) '\tFecha de modificación: $modification',
      if (labels != null) '\tEtiquetas: $labels',
      '\tEs Favorito?: ${isFavorite ? 'sí' : 'no'}',
      ')\n'
    ].join('\n');
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      if (name != null) "nombre": name,
      if (surname != null) "apellido": surname,
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (birthdate != null) "birthdate": birthdate,
      if (creation != null) "creation": creation,
      if (modification != null) "modification": modification,
      if (birthdate != null) "birthdate": birthdate,
      if (labels != null) "etiquetas": List.from(labels!),
      "isFavorite": isFavorite,
    };
  }

  //METODOS copy --------------------------------------------------------------
  ContactData copyWith({
    int? id,
    String? name,
    String? surname,
    String? email,
    String? phone,
    DateTime? birthdate,
    DateTime? creation,
    DateTime? modification,
    List<String>? labels,
    bool? isFavorite,
  }) {
    return ContactData(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthdate: birthdate ?? this.birthdate,
      creation: creation ?? this.creation,
      modification: modification ?? this.modification,
      labels: labels ?? (this.labels != null ? List.from(this.labels!) : null),
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  ContactData copyValuesFrom(ContactData copyFrom) {
    return ContactData(
      id: copyFrom.id,
      name: copyFrom.name,
      surname: copyFrom.surname,
      email: copyFrom.email,
      phone: copyFrom.phone,
      birthdate: copyFrom.birthdate,
      creation: copyFrom.creation,
      modification: copyFrom.modification,
      labels: copyFrom.labels,
      isFavorite: copyFrom.isFavorite,
    );
  }

  //METODOS misc --------------------------------------------------------------

  bool equals(ContactData other) {
    /*
    ContactData copyOther =
        other.copyWith(id: id, creation: creation, modification: modification);
    print(this);
    print(copyOther);*/

    //No funciona == directamente
    return (name == other.name) &&
        (surname == other.surname) &&
        (phone == other.phone) &&
        (email == other.email) &&
        (birthdate == other.birthdate);
  }

  bool isEmpty() {
    return equals(ContactData());
  }
}
