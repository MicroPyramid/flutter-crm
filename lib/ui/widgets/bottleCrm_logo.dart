import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: EdgeInsets.only(top: screenHeight * 0.1),
    //   child: Text(
    //     'Bottle CRM',
    //     style: GoogleFonts.robotoSlab(
    //         textStyle: TextStyle(
    //             color: Theme.of(context).secondaryHeaderColor,
    //             fontWeight: FontWeight.w600,
    //             fontSize: screenWidth / 13)),
    //   ),
    // );
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.1),
      // child: Image.asset('assets/images/logo.png', width: screenWidth * 0.4),
      child:
          SvgPicture.asset('assets/images/logo.svg', width: screenWidth * 0.4),
    );
  }
}
