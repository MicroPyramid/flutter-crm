import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class FooterBtnWidget extends StatelessWidget {

  final String labelText;
  @required
  final String buttonLabelText;
  final String routeName;
  FooterBtnWidget({this.labelText, this.buttonLabelText, this.routeName});

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
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth / 25)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, routeName);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.center,
                height: screenHeight * 0.06,
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    labelText == ""
                        ? Icon(Icons.arrow_back, color: Colors.white)
                        : Container(),
                    Text(
                      buttonLabelText,
                      style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth / 22)),
                    ),
                    labelText != ""
                        ? Icon(Icons.arrow_forward, color: Colors.white)
                        : Container()
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
