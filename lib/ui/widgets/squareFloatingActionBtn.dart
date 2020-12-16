import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareFloatingActionButton extends StatelessWidget {
  String _route;
  String btnTitle;

  SquareFloatingActionButton(this._route, this.btnTitle);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, _route);
      },
      child: Container(
        width: screenWidth * 0.35,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            color: Colors.red[50],
            border: Border.all(color: Color.fromRGBO(234, 67, 53, 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Icon(
                Icons.add,
                size: screenWidth / 18,
                color: Color.fromRGBO(234, 67, 53, 1),
              ),
            ),
            Container(
              child: Text(
                btnTitle,
                style: GoogleFonts.robotoSlab(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(234, 67, 53, 1),
                        fontSize: screenWidth / 25)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
