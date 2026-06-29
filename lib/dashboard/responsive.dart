import 'package:flutter/cupertino.dart';
//TODO 4.3 create a responsive class
class Responsive {
  bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }
  bool isTablet(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;

  }
  bool isMobile(BuildContext context){
    return
      MediaQuery.of(context).size.width < 600;
  }
}