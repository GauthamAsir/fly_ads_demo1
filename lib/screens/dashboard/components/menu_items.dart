import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/screens/profile/profile.dart';
import 'package:fly_ads_demo1/utils/auth_helper.dart';
import 'package:fly_ads_demo1/utils/responsive.dart';
import 'package:fly_ads_demo1/utils/utils.dart';

class MenuItems extends StatelessWidget {
  final int? selectedIndex;
  final Function onPressed;

  const MenuItems({Key? key, this.selectedIndex = 0, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _buildMobile(context), desktop: _buildDesktop(context));
  }

  Widget _buildMobile(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _iconAndTitle(context),
              const SizedBox(
                height: 20,
              ),
              _button(context, index: 0, btName: 'Home', onPressed: () {
                onPressed(0);
              }),
              _button(context, index: 1, btName: 'Products', onPressed: () {
                onPressed(1);
              }),
              _button(context, index: 2, btName: 'Pricing', onPressed: () {
                onPressed(2);
              }),
              _button(context, index: 3, btName: 'Contact', onPressed: () {
                onPressed(3);
              }),
              const SizedBox(
                height: 10,
              ),
              _buildProfile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconAndTitle(context),
          const Spacer(),
          _button(context, index: 0, btName: 'Home', onPressed: () {
            onPressed(0);
          }),
          _button(context, index: 1, btName: 'Products', onPressed: () {
            onPressed(1);
          }),
          _button(context, index: 2, btName: 'Pricing', onPressed: () {
            onPressed(2);
          }),
          _button(context, index: 3, btName: 'Contact', onPressed: () {
            onPressed(3);
          }),
          _buildProfile(context),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Profile()));
      },
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            if (snap.hasError) {
              return Utils.messageWidget(context, msg: snap.error.toString());
            }

            // log('Error: ' + snap.error.toString());
            // log('User: ' + snap.data.toString());
            // log('State: ' + snap.connectionState.toString());

            return snap.data == null
                ? Responsive.isDesktop(context)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _loginWidget(context, onPressed: () {
                            onPressed(4);
                          }),
                          _getStartedWidget(context, onPressed: () {
                            onPressed(5);
                          })
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _loginWidget(context, onPressed: () {
                            onPressed(4);
                          }),
                          const SizedBox(
                            height: 5,
                          ),
                          _getStartedWidget(context, onPressed: () {
                            onPressed(5);
                          })
                        ],
                      )
                : _buildUserProfileWidget(context);
          }),
    );
  }

  Widget _buildUserProfileWidget(BuildContext context) {
    return Responsive(
        mobile: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.black87,
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(getDisplayName()),
            _getStartedWidget(context, onPressed: () {
              onPressed(5);
            }, publishAD: true)
          ],
        ),
        desktop: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.black87,
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(getDisplayName()),
            _getStartedWidget(context, onPressed: () {
              onPressed(5);
            }, publishAD: true)
          ],
        ));
  }

  String getDisplayName() {
    AuthenticationHelper _auth = AuthenticationHelper();

    return _auth.user!.displayName == null
        ? 'Fly Ads'
        : _auth.user!.displayName!.isEmpty
            ? 'Fly Ads'
            : _auth.user!.displayName!;
  }

  Widget _getStartedWidget(BuildContext context,
      {required VoidCallback onPressed, bool publishAD = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: onPressed,
          child: Text(
            publishAD ? 'Publish AD' : 'Get Started',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontWeight: FontWeight.w600),
          )),
    );
  }

  Widget _loginWidget(BuildContext context, {required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_rounded),
            const SizedBox(
              width: 5,
            ),
            Text('Login',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _button(BuildContext context,
      {required int index, VoidCallback? onPressed, required String btName}) {
    return Container(
      width: Responsive.isDesktop(context) ? null : double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(selectedIndex == index
                  ? Colors.black12
                  : Colors.transparent)),
          child: Text(
            btName,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.w500),
          )),
    );
  }

  Widget _iconAndTitle(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.electric_bike_rounded,
          size: 40,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text('Fly Ads',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(
              height: 5,
            ),
            Flexible(
              child: Text('Communicate. Collaborate. Create',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 13),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        )
      ],
    );
  }
}
