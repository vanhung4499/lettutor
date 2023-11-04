class Topic {
  String id;
  String courseId;
  int orderCourse;
  String name;
  String nameFile;
  String description;
  String videoUrl;
  String createdAt;
  String updatedAt;

  Topic(
      {required this.id,
      required this.courseId,
      required this.orderCourse,
      required this.name,
      required this.nameFile,
      required this.description,
      required this.videoUrl,
      required this.createdAt,
      required this.updatedAt});

  static Topic getMockTopic() {
    return Topic(
      id: '964bed84-6450-49ee-92d5-e8c565864bd9',
      courseId: "964bed84-6450-49ee-92d5-e8c565864bd9",
      orderCourse: 1,
      name: "The Internet",
      nameFile:
          "https://api.app.lettutor.com/file/be4c3df8-3b1b-4c8f-a5cc-75a8e2e6626afileThe Internet.pdf",
      description: "",
      videoUrl: "",
      createdAt: "2021-09-03T04:35:50.484Z",
      updatedAt: "2021-09-03T04:35:50.484Z",
    );
  }
}
