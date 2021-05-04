import 'dart:typed_data';

import 'image_picker_helper.dart';

abstract class ImagePickerMain {
  Future<Uint8List> getImage();

  factory ImagePickerMain() => getImagePickerMain();
}
