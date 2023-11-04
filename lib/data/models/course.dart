import 'catrgory.dart';
import 'topic.dart';

class Course {
  String id;
  String name;
  String description;
  String imageUrl;
  String level;
  String reason;
  String purpose;
  String otherDetails;
  int defaultPrice;
  int coursePrice;
  String courseType;
  String sectionType;
  bool visible;
  String createdAt;
  String updatedAt;
  List<Topic> topics;
  List<Category> categories;

  Course(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.level,
      required this.reason,
      required this.purpose,
      required this.otherDetails,
      required this.defaultPrice,
      required this.coursePrice,
      required this.courseType,
      required this.sectionType,
      required this.visible,
      required this.createdAt,
      required this.updatedAt,
      required this.topics,
      required this.categories});

  static Course getMockCourse() {
    return Course(
      id: '964bed84-6450-49ee-92d5-e8c565864bd9',
      name: 'Life in the Internet Age',
      description: 'Let\'s discuss how technology is changing the way we live',
      imageUrl:
          'https://camblycurriculumicons.s3.amazonaws.com/5e0e8b212ac750e7dc9886ac?h=d41d8cd98f00b204e9800998ecf8427e',
      level: '4',
      reason:
          'Our world is rapidly changing thanks to new technology, and the vocabulary needed to discuss modern life is evolving almost daily. In this course you will learn the most up-to-date terminology from expertly crafted lessons as well from your native-speaking tutor.',
      purpose:
          'You will learn vocabulary related to timely topics like remote work, artificial intelligence, online privacy, and more. In addition to discussion questions, you will practice intermediate level speaking tasks such as using data to describe trends.',
      otherDetails: '1',
      defaultPrice: 1,
      coursePrice: 1,
      courseType: '1',
      sectionType: '1',
      visible: true,
      createdAt: '1',
      updatedAt: '1',
      topics: [Topic.getMockTopic()],
      categories: [],
    );
  }
}
