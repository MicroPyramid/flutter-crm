import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';



class FooterBtnWidget extends StatelessWidget {
  final String buttonRoute;
  final String buttonLabelText;
  final String labelText;
  FooterBtnWidget(this.labelText, this.buttonLabelText, this.buttonRoute);


  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.04),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              labelText,
              style: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(
                      color: Color.fromRGBO(5, 24, 62, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth / 30)),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, buttonRoute);
              currPageRoute = buttonRoute;
            },
            child: Container(
              alignment: Alignment.center,
              height: screenHeight * 0.06,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Text(
                buttonLabelText,
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth / 22)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
