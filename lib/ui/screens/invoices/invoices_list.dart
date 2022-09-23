import 'package:flutter/material.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';

class InvoicesList extends StatefulWidget {
  InvoicesList();
  @override
  State createState() => _InvoicesListState();
}

class _InvoicesListState extends State<InvoicesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Invoices List'),
        ),
        body: Center(
          child: Text('NO Invoice Found'),
        ),
        bottomNavigationBar: BottomNavigationBarWidget());
  }
}
