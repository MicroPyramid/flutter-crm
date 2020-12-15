import 'package:flutter/material.dart';
import 'package:flutter_crm/utils/utils.dart';

class ProfilePicViewWidget extends StatelessWidget {
  final List profilePicsList;
  ProfilePicViewWidget(this.profilePicsList);

  List<Widget> buildTags() {
    List<Widget> tagWidgets = <Widget>[];
    for (int i = 0; i < profilePicsList.length; i++) {
      tagWidgets.add(createTag(i));
    }
    return tagWidgets;
  }

  Widget createTag(profilePicIndex) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
          child: profilePicsList[profilePicIndex] != null &&
                  profilePicsList[profilePicIndex] != ""
              ? CircleAvatar(
                  radius: screenWidth / 20,
                  backgroundImage:
                      NetworkImage(profilePicsList[profilePicIndex]),
                )
              : CircleAvatar(
                  radius: screenWidth / 20,
                  child: Icon(
                    Icons.person,
                    size: screenWidth / 10,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.grey,
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5.0,
        direction: Axis.horizontal,
        children: buildTags(),
      ),
    );
  }
}
