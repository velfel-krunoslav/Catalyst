import 'package:frontend_mobile/sizer.dart';

class SizerWeb implements Sizer {
  double getImageHeight() {
    return 380.0;
  }

  bool isWeb() {
    return true;
  }
}

Sizer getSizer() => SizerWeb();
