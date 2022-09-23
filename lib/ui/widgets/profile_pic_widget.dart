import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:random_color/random_color.dart';

class ProfilePicViewWidget extends StatelessWidget {
  final List profilePicsList;
  ProfilePicViewWidget(this.profilePicsList);

  List<Widget> buildProfile() {
    List<Widget> tagWidgets = <Widget>[];
    for (int i = 0; i < profilePicsList.length; i++) {
      tagWidgets.add(createProfile(i));
    }
    return tagWidgets;
  }

  Widget createProfile(profilePicIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
      child: profilePicsList[profilePicIndex] != null &&
              profilePicsList[profilePicIndex] != "" &&
              Uri.parse(profilePicsList[profilePicIndex]).isAbsolute
          ? CircleAvatar(
              radius: screenWidth / 20,
              backgroundImage: NetworkImage(profilePicsList[profilePicIndex]),
            )
          : CircleAvatar(
              radius: screenWidth / 20,
              child: Text(profilePicsList[profilePicIndex],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: randomColor.randomColor(
                  colorBrightness: ColorBrightness.dark),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5.0,
        direction: Axis.horizontal,
        children: buildProfile(),
      ),
    );
  }
}
