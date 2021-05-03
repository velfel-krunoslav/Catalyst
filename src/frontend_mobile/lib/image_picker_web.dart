import 'dart:typed_data';

import 'package:image_picker_web/image_picker_web.dart';

import 'image_picker.dart';

class ImagePickerMainWeb implements ImagePickerMain {
  @override
  Future<Uint8List> getImage() async {
    return await ImagePickerWeb.getImage(outputType: ImageType.bytes);
  }
}

getImagePickerMain() => ImagePickerMainWeb();
