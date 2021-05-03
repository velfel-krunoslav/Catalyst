import 'dart:io' as io;
import 'dart:typed_data';

import 'package:frontend_mobile/image_picker.dart' as ipm;
import 'package:image_picker/image_picker.dart' as ip;

class ImagePickerMainIO implements ipm.ImagePickerMain {
  Future<Uint8List> getImage() async {
    final picker = ip.ImagePicker();
    var tmp = await picker.getImage(source: ip.ImageSource.gallery);
    return tmp.readAsBytes();
  }
}

getImagePickerMain() => ImagePickerMainIO();
