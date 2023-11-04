import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/data/models/topic.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'controllers/topic_controller.dart';

class TopicScreen extends GetView<TopicController> {
  final Topic topic = Get.arguments;

  TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    topic.nameFile = topic.nameFile.replaceAll(" ", "%20");
    print(topic.nameFile);

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.name),
      ),
      body: SfPdfViewer.network(
        topic.nameFile,
      ),
    );
  }
}
