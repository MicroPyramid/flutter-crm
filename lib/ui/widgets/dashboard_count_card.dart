import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CountCard extends StatelessWidget {
  final String icon;
  final Color color;
  final String lable;
  final String count;
  final String routeName;
  CountCard({this.icon, this.color, this.lable, this.count, this.routeName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: screenWidth * 0.46,
        height: screenHeight * 0.12,
        color: color,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: screenWidth / 14,
              child: SvgPicture.asset(
                icon,
                width: screenWidth / 12,
              ),
              backgroundColor: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(lable,
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                                fontSize: lable == "Opportunities"
                                    ? screenWidth / 30
                                    : screenWidth / 25))),
                  ),
                  Container(
                    child: Text(
                      count,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 15,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
