class Cuenta {
  int id;
  String name;
  String surname;
  String email;
  String phone;
  DateTime birthdate;
  DateTime creation;
  List<String> labels;
  bool isFavorite;

  Cuenta(
      {required this.id,
      required this.name,
      required this.surname,
      required this.email,
      required this.phone,
      required this.birthdate,
      required this.creation,
      required this.labels,
      this.isFavorite = false});

  @override
  String toString() {
    return [
      'PRODUCTO (',
      if (id != null) '\tId: $id',
      if (name != null) '\tNombre: $name',
      if (surname != null) '\tApellido: $surname',
      if (email != null) '\tEmail: $email',
      if (phone != null) '\tTelefono: $phone',
      if (birthdate != null) '\tFecha de nacimiento: $birthdate',
      if (creation != null) '\tFecha de creación: $creation',
      if (labels != null) '\tEtiquetas: $labels',
      if (isFavorite != null) '\tEs Favorito?: ${isFavorite ? 'sí' : 'no'}',
      ')\n'
    ].join('\n');
  }

  Cuenta copyWith({
    int? id,
    String? name,
    String? surname,
    String? email,
    String? phone,
    DateTime? birthdate,
    DateTime? creation,
    List<String>? labels,
    bool? isFavorite,
  }) {
    return Cuenta(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        birthdate: birthdate ?? this.birthdate,
        creation: creation ?? this.creation,
        labels: labels ?? List.from(this.labels),
        isFavorite: isFavorite ?? this.isFavorite);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      if (name != null) "nombre": name,
      if (surname != null) "apellido": surname,
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (birthdate != null) "birthdate": birthdate,
      if (creation != null) "creation": creation,
      if (labels != null) "etiquetas": List.from(labels!),
      if (isFavorite != null) "isFavorite": isFavorite,
    };
  }
}
