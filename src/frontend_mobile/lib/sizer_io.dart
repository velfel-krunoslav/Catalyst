import 'package:frontend_mobile/sizer.dart';

class SizerIO implements Sizer {
  double getImageHeight() {
    return 240.0;
  }
}

Sizer getSizer() => SizerIO();
