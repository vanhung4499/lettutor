import 'dart:convert';

import 'package:flutter/foundation.dart';

class UploadAvatarRequest {
  Uint8List? avatar;

  UploadAvatarRequest({
    this.avatar,
  });

  Map<String, dynamic> toJson() => {
    "avatar": base64Encode(avatar!) ?? "",
  };
}
