import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountOverviewWidget extends StatelessWidget {
  // AccountOverviewWidget(this._input_data);
  // List _input_data;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 0.66,
      height: screenSize.height * 0.66,
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, offset: Offset.zero)],
          border: Border.all(style: BorderStyle.solid)),
      child: Card(
        child: Text('Dummy Data in here in multiple Widgets'),
      ),
    );
  }
}
