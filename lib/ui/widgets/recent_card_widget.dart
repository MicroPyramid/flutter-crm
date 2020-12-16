import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentCardWidget extends StatelessWidget {
  final String source;
  final String name;
  final String date;
  final String city;
  final String email;

  RecentCardWidget({this.source, this.name, this.date, this.city, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.09,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth * 0.6,
                child: Text(name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth / 24))),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: screenWidth * 0.25,
                child: Text(date,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                            color: bottomNavBarTextColor,
                            fontSize: screenWidth / 25))),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: source == "opportunities"
                    ? screenWidth * 0.5
                    : screenWidth * 0.3,
                child: Text(city,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                            color: bottomNavBarTextColor,
                            fontSize: screenWidth / 26))),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: source == "opportunities"
                    ? screenWidth * 0.35
                    : screenWidth * 0.55,
                child: Text(email,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                            color: bottomNavBarTextColor,
                            fontSize: screenWidth / 26))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
