import 'package:lettutor/data/models/tutor/tutor_detail.dart';

class Tutor {
  TutorDetail tutorDetail;
  String id;
  String userId;
  String video;
  String bio;
  String education;
  String experience;
  String profession;
  String accent;
  String targetStudent;
  String interests;
  String languages;
  String specialties;
  String resume;
  bool isActivated;
  bool isNative;
  String createdAt;
  String updatedAt;
  bool isFavorite;
  double rating;
  int price;

  Tutor({
    required this.tutorDetail,
    required this.id,
    required this.userId,
    required this.video,
    required this.bio,
    required this.education,
    required this.experience,
    required this.profession,
    required this.accent,
    required this.targetStudent,
    required this.interests,
    required this.languages,
    required this.specialties,
    required this.resume,
    required this.isActivated,
    required this.isNative,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.rating,
    required this.price,
  });

  static Tutor getMockTutor() {
    return Tutor(
      tutorDetail: TutorDetail.getMockTutorDetail(),
      id: '1',
      userId: '1',
      video: 'https://www.youtube.com/watch?v=1yUCuS8vJvU',
      bio: 'I am a teacher',
      education: 'I have a degree',
      experience: 'I have 10 years of experience',
      profession: 'I am a teacher',
      accent: 'I am a teacher',
      targetStudent: 'I am a teacher',
      interests: 'I am a teacher',
      languages: 'I am a teacher',
      specialties: 'I am a teacher',
      resume: 'I am a teacher',
      isActivated: true,
      isNative: true,
      createdAt: '2021-08-01T00:00:00.000Z',
      updatedAt: '2021-08-01T00:00:00.000Z',
      isFavorite: true,
      rating: 4.5,
      price: 10,
    );
  }
}
