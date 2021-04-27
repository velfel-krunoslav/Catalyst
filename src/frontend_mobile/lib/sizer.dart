import 'package:frontend_mobile/sizer_helper.dart';

abstract class Sizer {
  double getImageHeight();
  factory Sizer() => getSizer();
}
