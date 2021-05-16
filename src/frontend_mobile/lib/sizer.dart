import './sizer_helper.dart';

abstract class Sizer {
  double getImageHeight();
  bool isWeb();
  factory Sizer() => getSizer();
}
