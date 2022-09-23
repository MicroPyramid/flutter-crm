import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';
import 'package:random_color/random_color.dart';

class TagViewWidget extends StatelessWidget {
  final List tags;
  TagViewWidget(this.tags);

  List<Widget> buildTags() {
    List<Widget> tagWidgets = <Widget>[];
    for (int i = 0; i < tags.length; i++) {
      tagWidgets.add(createTag(i));
    }
    return tagWidgets;
  }

  Widget createTag(tagIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
      color: randomColor.randomColor(colorBrightness: ColorBrightness.light),
      child: Text(
        tags[tagIndex]['name'],
        style: TextStyle(color: Colors.white, fontSize: 12.0),
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
        children: buildTags(),
      ),
    );
  }
}
