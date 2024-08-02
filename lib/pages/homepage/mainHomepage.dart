import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/config/sharePreference.dart';
import 'package:pickme_mobile/pages/homepage/bookings/bookings.dart';
import 'package:pickme_mobile/pages/homepage/inviteFriend/inviteFriend.dart';
import 'package:pickme_mobile/pages/homepage/profile/profile.dart';
import 'package:pickme_mobile/pages/homepage/wallet/wallet.dart';
import 'package:pickme_mobile/pages/homepage/workerBookings/workerBookings.dart';
import 'package:pickme_mobile/pages/homepage/workerHome/widget/workerHomeDrawer.dart';
import 'package:pickme_mobile/pages/homepage/workerHome/workerHome.dart';
import 'package:pickme_mobile/pages/modules/worker/workerMap/workerMap.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'home/home.dart';
import 'workerHome/widget/workerDeliveryRunnerMultiRequestDialog.dart';
import 'workerHome/widget/workerDeliveryRunnerSingleRequestDialog.dart';
import 'workerHome/widget/workerRideRequestDialog.dart';

class MainHomepage extends StatefulWidget {
  final int selectedPage;
  final bool isWorker;

  const MainHomepage({
    super.key,
    this.selectedPage = 0,
    this.isWorker = false,
  });

  @override
  State<MainHomepage> createState() => _MainHomepageState();
}

class _MainHomepageState extends State<MainHomepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  bool _isLoading = false, _isWorkerMode = false;

  Position? _currentLocation;

  final List<String> _bottomIcons = [
    Images.home,
    Images.bookings,
    Images.wallet,
    Images.inviteFriend,
    Images.profile,
  ];

  final List<String> _bottomIconsUnclick = [
    Images.homeUnclick,
    Images.bookingsUnclick,
    Images.walletUnclick,
    Images.inviteFriendUnclick,
    Images.profileUnclick,
  ];

  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _isWorkerMode = widget.isWorker;
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: widget.isWorker
          ? workerHomeDrawer(
              context: context,
              isWorkerMode: _isWorkerMode,
              onWorkerMode: (bool value) => _onWorkerMode(value),
              onMyServices: () => navigation(
                context: context,
                pageName: "myServices",
              ),
              onNotifications: () => navigation(
                context: context,
                pageName: "notifications",
              ),
              onRewards: () => navigation(
                context: context,
                pageName: "workerAppreciation",
              ),
              onPromotions: () => navigation(
                context: context,
                pageName: "promotions",
              ),
              onSettings: () => navigation(
                context: context,
                pageName: "accountsettings",
              ),
              onSupport: () => navigation(
                context: context,
                pageName: "support",
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        unselectedFontSize: 10,
        backgroundColor: BColors.white,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: BColors.primaryColor,
        unselectedItemColor: BColors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: Styles.h8Primary,
        onTap: (int index) {
          _onItemTapped(index);
        },
        items: <BottomNavigationBarItem>[
          for (int x = 0; x < _bottomIcons.length; ++x)
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                x == _selectedIndex ? _bottomIcons[x] : _bottomIconsUnclick[x],
                // ignore: deprecated_member_use
                color:
                    _selectedIndex == x ? BColors.primaryColor : BColors.black,
              ),
              label: x == 0
                  ? "Home"
                  : x == 1
                      ? "Bookings"
                      : x == 2
                          ? "Wallet"
                          : x == 3
                              ? "Invite Friends"
                              : "Profile",
            ),
        ],
      ),
      body: Stack(
        children: [
          if (_currentLocation != null) _widgetOptions[_selectedIndex],
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onWorkerMode(bool value) async {
    _isWorkerMode = value;
    await saveBoolShare(key: "isWorker", data: value);
    setState(() {});
    if (!mounted) return;
    navigation(context: context, pageName: "homepage");
  }

  void _onIncomingRideRequest() {
    showModalBottomSheet<dynamic>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: BColors.white,
      builder: (context) => WorkerRideRequestDialog(
        onReject: () {
          navigation(context: context, pageName: "back");
          _onRejectRideRequest();
        },
        onAccept: () {
          navigation(context: context, pageName: "back");
          _onAcceptRideRequest(ServicePurpose.ride);
        },
        remainTime: 15,
      ),
    );

    // showModalBottomSheet<dynamic>(
    //   context: context,
    //   isDismissible: false,
    //   enableDrag: false,
    //   isScrollControlled: true,
    //   useRootNavigator: true,
    //   backgroundColor: BColors.white,
    //   builder: (context) => WorkerDeliveryRunnerSingleRequestDialog(
    //     onReject: () {
    //       navigation(context: context, pageName: "back");
    //       _onRejectRideRequest();
    //     },
    //     onAccept: () {
    //       navigation(context: context, pageName: "back");
    //       _onAcceptRideRequest(ServicePurpose.deliveryRunnerSingle);
    //     },
    //     remainTime: 15,
    //   ),
    // );

    // showModalBottomSheet<dynamic>(
    //   context: context,
    //   isDismissible: false,
    //   enableDrag: false,
    //   isScrollControlled: true,
    //   useRootNavigator: true,
    //   backgroundColor: BColors.white,
    //   builder: (context) => WorkerDeliveryRunnerMultiRequestDialog(
    //     onReject: () {
    //       navigation(context: context, pageName: "back");
    //       _onRejectRideRequest();
    //     },
    //     onAccept: () {
    //       navigation(context: context, pageName: "back");
    //       _onAcceptRideRequest(ServicePurpose.deliveryRunnerMultiple);
    //     },
    //     remainTime: 15,
    //   ),
    // );
  }

  void _onAcceptRideRequest(ServicePurpose purpose) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkerMap(
          currentLocation: _currentLocation,
          mapNextAction: WorkerMapNextAction.accept,
          servicePurpose: purpose,
        ),
      ),
    );
  }

  void _onRejectRideRequest() {}

  Future<void> _getCurrentLocation() async {
    WidgetsFlutterBinding.ensureInitialized();
    setState(() => _isLoading = true);
    _currentLocation = await Geolocator.getCurrentPosition();
    setState(() => _isLoading = false);

    _widgetOptions = <Widget>[
      widget.isWorker
          ? WorkerHome(
              currentLocation: _currentLocation!,
              scaffoldKey: _scaffoldKey,
            )
          : Home(
              currentLocation: _currentLocation!,
              onProfile: () => _onItemTapped(4),
            ),
      widget.isWorker
          ? WorkerBookings(scaffoldKey: _scaffoldKey)
          : const Bookings(),
      const Wallet(),
      const InviteFriends(),
      Profile(
        onMyBookings: () => _onItemTapped(1),
        onWallet: () => _onItemTapped(2),
      ),
    ];
    _selectedIndex = widget.selectedPage;

    if (widget.isWorker) {
      await Future.delayed(const Duration(seconds: 3), () async {
        _onIncomingRideRequest();
      });
    }
  }
}
