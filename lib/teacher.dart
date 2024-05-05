class Teacher {
  final String name;
  final List<Subject> subjects;
  const Teacher(this.name, this.subjects);
}

enum Subject {
  belly,
  heart,
  emergency,
  icu,
  digestion,
}

extension SubjectExtension on Subject {
  String get chinese {
    switch (this) {
      case Subject.belly:
        return '腹部';
      case Subject.heart:
        return '心脏';
      case Subject.emergency:
        return '急诊';
      case Subject.icu:
        return 'ICU';
      default :
        return '';
    }
  }
}
