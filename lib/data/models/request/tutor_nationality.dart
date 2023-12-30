class TutorNationality {
  final String code;
  final String name;

  TutorNationality(this.code, this.name);
}

extension TutorNationalityExtension on TutorNationality {
  bool get isVietNamese => code == 'vn';
  bool get isNative => code == 'nt';
}

List nationalityConstants = [
  TutorNationality('vn', 'Vietnamese Tutor'),
  TutorNationality('fr', 'Foreigner Tutor'),
  TutorNationality('nt', 'Native Tutor')
];