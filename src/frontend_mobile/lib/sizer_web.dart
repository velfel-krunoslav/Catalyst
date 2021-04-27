import 'package:frontend_mobile/sizer.dart';

class SizerWeb implements Sizer {
  double getImageHeight() {
    return 380.0;
  }
}

Sizer getSizer() => SizerWeb();
