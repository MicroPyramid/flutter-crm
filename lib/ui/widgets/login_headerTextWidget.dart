import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.1),
      child: Text(
        'Bottle CRM',
        style: GoogleFonts.robotoSlab(
            textStyle: TextStyle(
                color: Color.fromRGBO(5, 24, 62, 1),
                fontWeight: FontWeight.w500,
                fontSize: screenWidth / 13)),
      ),
    );
  }
}
