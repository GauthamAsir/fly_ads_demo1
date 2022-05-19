import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/screens/contact/contact_screen.dart';
import 'package:fly_ads_demo1/screens/dashboard/components/menu_items.dart';
import 'package:fly_ads_demo1/screens/fly_dashboard/fly_ads_dashboard.dart';
import 'package:fly_ads_demo1/screens/home/home.dart';
import 'package:fly_ads_demo1/screens/pricing/pricing_screen.dart';
import 'package:fly_ads_demo1/screens/products/products_screen.dart';
import 'package:fly_ads_demo1/screens/sign_in/sign_in.dart';
import 'package:fly_ads_demo1/screens/sign_up/sign_up.dart';
import 'package:fly_ads_demo1/utils/auth_helper.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/responsive.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  bool showAuthWidget = false, showLogin = true;

  List titleNames = ['Home', 'Service', 'Pricing', 'Contact'];

  AuthenticationHelper authenticationHelper = AuthenticationHelper();

  void authenticate({bool login = true, bool signUp = false}) async {
    setState(() {
      showAuthWidget = true;
      showLogin = true;
    });
  }

  void getStarted() {
    if (authenticationHelper.user == null) {
      showAuthWidget = true;
      showLogin = true;
      setState(() {});
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FlyAdsDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: bgColor,
              title: Text(titleNames[_currentIndex]),
              titleTextStyle: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.white),
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
          ),
          drawer: Responsive.isDesktop(context)
              ? null
              : MenuItems(
            onPressed: (int index) {
                log('message: ' + index.toString());

                if (index == 4) {
                  Navigator.of(context).pop();
                  authenticate();
                  return;
                }

                if (index == 5) {
                  Navigator.of(context).pop();
                  getStarted();
                  return;
                }

                setState(() {
                  _currentIndex = index;
                });
                Navigator.of(context).pop();
              },
            selectedIndex: _currentIndex,
          ),
          body: Container(
            constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Stack(
          children: [
            Column(
              children: [
                if (Responsive.isDesktop(context))
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: _currentIndex == 2 ? secondaryColor : null,
                      child: MenuItems(
                        onPressed: (int index) {
                          log('message: ' + index.toString());

                          if (index == 4) {
                            authenticate();
                            return;
                          }

                          if (index == 5) {
                            getStarted();
                            return;
                          }
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        selectedIndex: _currentIndex,
                      ),
                    ),
                  ),
                Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      physics:
                          _currentIndex == 1 && Responsive.isMobile(context)
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: getCurrentScreen(),
                      ),
                    ))
              ],
            ),
            AnimatedSwitcher(
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.25),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              duration: const Duration(milliseconds: 250),
              child: showAuthWidget ? _sideWidget() : Container(),
            )
          ],
        ),
      ),
    ));
  }

  Widget _sideWidget() {
    Widget child = AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      duration: const Duration(milliseconds: 250),
      child: showLogin
          ? SignIn(
              onSignUpPressed: () {
                setState(() {
                  showAuthWidget = true;
                  showLogin = false;
                });
              },
            )
          : SignUp(
              onSignInPressed: () {
                setState(() {
                  showAuthWidget = true;
                  showLogin = true;
                });
              },
            ),
    );

    return Responsive(
      mobile: Container(
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.black38),
          child: Center(
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                showAuthWidget = false;
                              });
                            },
                            icon: const Icon(Icons.close_rounded)),
                        alignment: Alignment.centerRight),
                    const SizedBox(
                      height: 20,
                    ),
                    child,
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                )),
          )),
      desktop: _desktopAuthWidget(child),
      mobileLarge: _desktopAuthWidget(child),
      tablet: _desktopAuthWidget(child),
    );
  }

  Widget _desktopAuthWidget(Widget child) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black38),
      child: Row(
        children: [
          Expanded(
              flex: Responsive.isDesktop(context)
                  ? 2
                  : Responsive.isTablet(context)
                      ? 2
                      : Responsive.isMobileLarge(context)
                          ? 0
                          : 1,
              child: Container(
                color: Colors.transparent,
              )),
          Expanded(
              child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(-10, 5),
                            blurRadius: 20)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Align(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  showAuthWidget = false;
                                });
                              },
                              icon: const Icon(Icons.close_rounded)),
                          alignment: Alignment.centerRight),
                      Expanded(child: Center(child: child)),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        // return const SecondPhase(campaignName: 'TEST');
        return const HomeScreen(
          key: ValueKey(0),
        );
      case 1:

        /// Service
        return const ProductsScreen(
          key: ValueKey(1),
        );
      case 2:
        return const PricingScreen(
          key: ValueKey(2),
        );
      case 3:
        return const ContactScreen(
          key: ValueKey(3),
        );
      default:
        return const HomeScreen(
          key: ValueKey(0),
        );
    }
  }
}
