import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

class ImageData {
  final Uint8List? image;
  final String? path;
  ImageData(this.image, this.path);
}

@injectable
class ImagePickerService {
  Future pickFile() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      return File(result!.files.single.path!);
    } catch (e) {
      log("Pick image error:${e.toString()}");
    }
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<ImageData?> selectedImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      final image = await file.readAsBytes();
      final path = file.path;
      return ImageData(image, path);
    }
    return null;
  }

  void pickListImage(Function(List<Uint8List>) callback) async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? files = await picker.pickMultiImage();
    List<Uint8List> images = [];
    for (var file in files) {
      Uint8List image = await file.readAsBytes();
      images.add(image);
    }
    callback(images);
  }
}
