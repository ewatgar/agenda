import 'package:diacritic/diacritic.dart';

int diacriticsCaseAwareCompareTo(String a, String b) {
  String aFormat = removeDiacritics(a.toUpperCase());
  String bFormat = removeDiacritics(b.toUpperCase());
  return aFormat.compareTo(bFormat);
}
