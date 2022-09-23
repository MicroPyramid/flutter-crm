import 'package:flutter/material.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';

class DocumentsList extends StatefulWidget {
  DocumentsList();
  @override
  State createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Documents List'),
        ),
        body: Center(
          child: Text('No Documents Found'),
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }
}
