import 'package:bottle_crm/ui/widgets/tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:bottle_crm/utils/utils.dart';

class RecentCardWidget extends StatelessWidget {
  final String? source;
  final String? name;
  final String? date;
  final String? city;
  final String? email;
  final String? photoUrl;
  final String? createdBy;
  final List? tags;

  RecentCardWidget(
      {this.source,
      this.name,
      this.date,
      this.city,
      this.email,
      this.photoUrl,
      this.createdBy,
      this.tags});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: screenHeight * 0.09,
      //color: Colors.white,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: screenWidth * 0.5,
                  child: Text(name!.capitalizeFirstofEach(),
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth / 21))),
              Container(
                width: screenWidth * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    photoUrl != ""
                        ? CircleAvatar(
                            radius: screenWidth / 28,
                            backgroundImage: NetworkImage(photoUrl!),
                          )
                        : CircleAvatar(
                            radius: screenWidth / 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              createdBy![0].allInCaps,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                    SizedBox(width: 5.0),
                    Text(createdBy!.capitalizeFirstofEach(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth / 25))
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: screenWidth * 0.5, child: TagViewWidget(tags!)),
              Text(date!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: bottomNavBarTextColor,
                      fontSize: screenWidth / 26)),
            ],
          ),
        ],
      ),
    );
  }
}
