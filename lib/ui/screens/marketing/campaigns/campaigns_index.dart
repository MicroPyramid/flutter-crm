import 'package:flutter/material.dart';
import 'package:flutter_crm/ui/widgets/side_menu.dart';
import 'package:flutter_crm/utils/utils.dart';

class MarketingCampaignsScreen extends StatefulWidget {
  MarketingCampaignsScreen();
  @override
  State createState() => _MarketingCampaignsScreenState();
}

class _MarketingCampaignsScreenState extends State<MarketingCampaignsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Campaigns'),
          ),
          drawer: SideMenuDrawer(),
          body: Center(
            child: Text("This page under Development..."),
          )),
    );
  }
}
