import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/constants.dart';
import 'package:fly_ads_demo1/responsive.dart';
import 'package:fly_ads_demo1/screens/contact/contact_screen.dart';
import 'package:fly_ads_demo1/screens/dashboard/components/menu_items.dart';
import 'package:fly_ads_demo1/screens/home/home.dart';
import 'package:fly_ads_demo1/screens/pricing/pricing_screen.dart';
import 'package:fly_ads_demo1/screens/products/products_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  List titleNames = ['Home', 'Products', 'Pricing', 'Contact'];

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
                if (index >= 4) {
                  Navigator.of(context).pop();
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
        child: Column(
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: Container(
                  color: _currentIndex == 2 ? secondaryColor : null,
                  child: MenuItems(
                    onPressed: (int index) {
                      if (index >= 4) {
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
                  physics: const BouncingScrollPhysics(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: getCurrentScreen(),
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  Widget getCurrentScreen() {

    switch (_currentIndex) {
      case 0:
        return const HomeScreen(
          key: ValueKey(0),
        );
      case 1:
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
