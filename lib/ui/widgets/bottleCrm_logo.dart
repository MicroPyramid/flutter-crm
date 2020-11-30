import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';

class HeaderTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.1),
      child:
          SvgPicture.asset('assets/images/logo.svg', width: screenWidth * 0.4),
    );
  }
}
