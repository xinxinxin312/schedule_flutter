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
  puwai,
  fuchan,
  qianbiao,
  xueguan,
  ct,
  fangshe,
  mr,
  heyixue,
  jieru,
  jidong,
  fubujieru,
  pufangweichang,
  xiaoer,
  mrjieru,
  xinzangfuchan,
  empty,
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
      case Subject.digestion:
        return '消化';
      case Subject.puwai:
        return '普外';
      case Subject.fuchan:
        return '妇产';
      case Subject.qianbiao:
        return '浅表';
      case Subject.xueguan:
        return '血管';
      case Subject.ct:
        return 'CT';
      case Subject.fangshe:
        return '放射';
      case Subject.mr:
        return 'MR';
      case Subject.heyixue:
        return '核医学';
      case Subject.jieru:
        return '介入';
      case Subject.jidong:
        return '机动';
      case Subject.fubujieru:
        return '腹部介入';
      case Subject.pufangweichang:
        return '普放胃肠';
      case Subject.xiaoer:
        return '小儿';
      case Subject.mrjieru:
        return 'MR介入';
      case Subject.xinzangfuchan:
        return '心脏妇产';
      case Subject.empty:
        return '';
      default:
        return '';
    }
  }
}

Subject findSubject(String name) {
  for (Subject subject in Subject.values) {
    if (subject.chinese == name) {
      return subject;
    }
  }
  return Subject.empty;
}
