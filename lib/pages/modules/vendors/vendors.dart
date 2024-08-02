import 'package:flutter/material.dart';
import 'package:pickme_mobile/pages/modules/vendors/widget/vendorsWidget.dart';

class Vendors extends StatefulWidget {
  const Vendors({super.key});

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
  FocusNode? _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vendorsWidget(
        context: context,
        searchFocusNode: _searchFocusNode,
        onSearchChange: (String text) {},
        onVentorFilter: () {},
      ),
    );
  }
}
