import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/pages/homepage/home/widget/homeDeliveryOptionsWidget.dart';
import 'package:pickme_mobile/pages/modules/deliveries/deliveryRunner/deliveryRunnerType/deliveryRunnerType.dart';
import 'package:pickme_mobile/pages/modules/deliveries/personalShopper/personalShopping/personalShopping.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMap/rideMap.dart';

import 'widget/homeWidget.dart';

class Home extends StatefulWidget {
  final Position currentLocation;
  final VoidCallback onProfile;

  const Home({
    super.key,
    required this.currentLocation,
    required this.onProfile,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;

  Position? _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.currentLocation;
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          homeWidget(
            context: context,
            onSos: () {},
            onNotification: () => navigation(
              context: context,
              pageName: "notifications",
            ),
            onRide: () => _onRide(),
            onDelivery: () => _onDelivery(),
            currentLocation: _currentLocation,
            onProfile: widget.onProfile,
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    WidgetsFlutterBinding.ensureInitialized();
    // setState(() => _isLoading = true);
    _currentLocation = await Geolocator.getCurrentPosition();
    setState(() => _isLoading = false);
  }

  void _onRide() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideMap(currentLocation: _currentLocation!),
      ),
    );
  }

  void _onDelivery() {
    showModalBottomSheet(
      context: context,
      builder: (context) => homeDeliveryOptionsWidget(
        context: context,
        onDelivery: (String type) {
          if (type == "personalShopper") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalShopping(),
              ),
            );
          } else if (type == "deliveryRunner") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DeliveryRunnerType(),
              ),
            );
          } else {
            navigation(context: context, pageName: "vendors");
          }
        },
      ),
    );
  }
}
