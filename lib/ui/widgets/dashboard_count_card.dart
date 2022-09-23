import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:flutter_svg/svg.dart';

class CountCard extends StatelessWidget {
  final String? icon;
  final Color? color;
  final String? lable;
  final int? count;
  final String? routeName;
  final int? index;
  CountCard(
      {this.icon,
      this.color,
      this.lable,
      this.count,
      this.routeName,
      this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        currentBottomNavigationIndex = index.toString();
        Navigator.pushNamed(context, routeName!);
      },
      child: Container(
        width: screenWidth * 0.46,
        height: screenHeight * 0.12,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.grey.shade300, width: 2.0)),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: screenWidth / 14,
              child: SvgPicture.asset(
                icon!,
                color: Colors.blueGrey[800],
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
                    child: Text(lable!,
                        style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: lable == "Opportunities"
                                ? screenWidth / 30
                                : screenWidth / 25)),
                  ),
                  Container(
                    child: Text(
                      count!.toString(),
                      style: TextStyle(
                          color: Colors.blueGrey[800],
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
