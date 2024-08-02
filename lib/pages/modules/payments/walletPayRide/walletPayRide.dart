import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/pages/modules/deliveries/deliveryRunner/deliveryRecipient/deliveryCharges/widget/deliverySuccessDialog.dart';
import 'package:pickme_mobile/pages/modules/rides/rateRide/rateRide.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMap/rideMap.dart';
import 'package:pickme_mobile/spec/arrays.dart';

import 'widget/walletPayRideWidget.dart';

class WalletPayRide extends StatefulWidget {
  final ServicePurpose purpose;
  final Map<dynamic, dynamic>? deliveryAddresses;

  const WalletPayRide({
    super.key,
    this.purpose = ServicePurpose.ride,
    this.deliveryAddresses,
  });

  @override
  State<WalletPayRide> createState() => _WalletPayRideState();
}

class _WalletPayRideState extends State<WalletPayRide> {
  Position? _currentLocation;

  final _codeController = new TextEditingController();
  final _codeFocusNode = new FocusNode();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          walletPayRideWidget(
            context: context,
            codeController: _codeController,
            codeFocusNode: _codeFocusNode,
            onPay: () => _onPay(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  void _onPay() {
    if (widget.purpose == ServicePurpose.ride) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const RateRide(),
          ),
          (Route<dynamic> route) => false);
    } else if (widget.purpose == ServicePurpose.deliveryRunnerSingle ||
        widget.purpose == ServicePurpose.deliveryRunnerMultiple) {
      _onSubmitDeliveryRunner();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideMap(
            currentLocation: _currentLocation!,
            servicePurpose: widget.purpose,
            mapNextAction: RideMapNextAction.searchingDriver,
          ),
        ),
      );
    }
  }

  void _onSubmitDeliveryRunner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => deliverySuccessDialog(
        context: context,
        onDone: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideMap(
                currentLocation: _currentLocation!,
                servicePurpose: widget.purpose,
                mapNextAction: RideMapNextAction.searchingDriver,
                deliveryAddresses: widget.deliveryAddresses,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    WidgetsFlutterBinding.ensureInitialized();
    setState(() => _isLoading = true);
    _currentLocation = await Geolocator.getCurrentPosition();
    setState(() => _isLoading = false);
  }
}
