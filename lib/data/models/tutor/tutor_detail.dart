import 'package:flutter/material.dart';
import 'package:lettutor/data/models/course.dart';

class TutorDetail {
  String id;
  String level;
  String email;
  String google;
  String facebook;
  String apple;
  String avatar;
  String name;
  String country;
  String phone;
  String language;
  String birthday;
  bool requestPassword;
  bool isActivated;
  bool isPhoneActivated;
  String requireNote;
  int timezone;
  double rating;
  String phoneAuth;
  bool isPhoneAuthActivated;
  String createdAt;
  String updatedAt;
  String deletedAt;
  List<Feedback> feedbacks;
  List<Course> courses;

  TutorDetail({
    required this.id,
    required this.level,
    required this.email,
    required this.google,
    required this.facebook,
    required this.apple,
    required this.avatar,
    required this.name,
    required this.country,
    required this.phone,
    required this.language,
    required this.birthday,
    required this.requestPassword,
    required this.isActivated,
    required this.isPhoneActivated,
    required this.requireNote,
    required this.timezone,
    required this.rating,
    required this.phoneAuth,
    required this.isPhoneAuthActivated,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.feedbacks,
    required this.courses,
  });

  static TutorDetail getMockTutorDetail() {
    return TutorDetail(
      id: '1',
      level: '1',
      email: '',
      google: '',
      facebook: '',
      apple: '',
      avatar: 'https://api.app.lettutor.com/avatar/83802576-70fe-4394-b27a-3d9e8b50f1b7avatar1649512219387.jpg',
      name: 'April Baldo',
      country: 'Philippines',
      phone: '0123456789',
      language: 'English',
      birthday: '1999-01-01',
      requestPassword: false,
      isActivated: true,
      isPhoneActivated: true,
      requireNote: '',
      timezone: 7,
      rating: 4.5,
      phoneAuth: '',
      isPhoneAuthActivated: true,
      createdAt: '2021-08-01T00:00:00.000Z',
      updatedAt: '2021-08-01T00:00:00.000Z',
      deletedAt: '2021-08-01T00:00:00.000Z',
      feedbacks: [],
      courses: [],
    );
  }
}
