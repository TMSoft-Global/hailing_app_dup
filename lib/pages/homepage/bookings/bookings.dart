import 'package:flutter/material.dart';

import 'widget/bookingsWidget.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
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
      body: bookingsWidget(
        context: context,
        searchFocusNode: _searchFocusNode,
        onSearchChange: (String text) {},
        onBookingFilter: () {},
      ),
    );
  }
}
