import 'package:flutter/material.dart';
import 'package:flutter_crm/bloc/account_bloc.dart';
import 'package:flutter_crm/bloc/contact_bloc.dart';
import 'package:flutter_crm/bloc/lead_bloc.dart';
import 'package:flutter_crm/bloc/user_bloc.dart';
import 'package:flutter_crm/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareFloatingActionButton extends StatelessWidget {
  final String _route;
  final String btnTitle;
  final String moduleName;

  SquareFloatingActionButton(this._route, this.btnTitle, this.moduleName);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (moduleName == "Accounts") {
          accountBloc.cancelCurrentEditAccount();
        }
        leadBloc.cancelCurrentEditLead();
        contactBloc.cancelCurrentEditContact();
        userBloc.cancelCurrentEditUser();
        Navigator.pushNamed(context, _route);
      },
      child: Container(
        width: screenWidth * 0.4,
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
