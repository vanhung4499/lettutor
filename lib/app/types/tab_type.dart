enum TabType { home, tutors, courses, schedule, profile }

extension TabItem on TabType {
  int get index {
    switch (this) {
      case TabType.home:
        return 0;
      case TabType.tutors:
        return 1;
      case TabType.courses:
        return 2;
      case TabType.schedule:
        return 3;
      case TabType.profile:
        return 4;
      default:
        return 0;
    }
  }

  String get title {
    switch (this) {
      case TabType.home:
        return "Home";
      case TabType.tutors:
        return "Tutors";
      case TabType.courses:
        return "Courses";
      case TabType.schedule:
        return "Schedule";
      case TabType.profile:
        return "Profile";
      default:
        return "Home";
    }
  }
}
