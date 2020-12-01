import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentCardWidget extends StatelessWidget {

  final String position00;
  final String position01;
  final String position10;
  final String position11;

  RecentCardWidget({this.position00, this.position01, this.position10, this.position11=""});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: Colors.white,
        child: Container(
          height: screenHeight*0.07,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    position00,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 128, 1),
                          fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width / 25))
                  ),
                  Text(
                    position01,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                          // color: Colors.white,
                          // fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.width / 25))
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    position10,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                          // color: Colors.white,
                          // fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.width / 30))
                  ),
                  Text(
                    position11,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                          // color: Colors.white,
                          // fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.width / 30))
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
