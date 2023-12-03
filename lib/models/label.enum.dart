enum Label {
  pareja,
  amistad,
  familia,
  trabajo,
  deporte,
  other;

  static Label parse(String str) {
    switch (str.toLowerCase()) {
      case 'pareja':
        return Label.pareja;
      case 'amistad':
        return Label.amistad;
      case 'familia':
        return Label.familia;
      case 'trabajo':
        return Label.trabajo;
      case 'deporte':
        return Label.deporte;
      default:
        return Label.other;
    }
  }

  @override
  String toString() {
    switch (this) {
      case Label.pareja:
        return 'Pareja';
      case Label.amistad:
        return 'Amistad';
      case Label.familia:
        return 'Familia';
      case Label.trabajo:
        return 'Trabajo';
      case Label.deporte:
        return 'Deporte';
      case Label.other:
        return 'Other';
    }
  }

  int priority() {
    switch (this) {
      case Label.pareja:
        return 1;
      case Label.amistad:
        return 2;
      case Label.familia:
        return 3;
      case Label.trabajo:
        return 4;
      case Label.deporte:
        return 5;
      case Label.other:
        return 6;
    }
  }

  int compareTo(Label label) {
    if (this.priority() > label.priority()) {
      return 1;
    } else {
      return -1;
    }
  }
}
