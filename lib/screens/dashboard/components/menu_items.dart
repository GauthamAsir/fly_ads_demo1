import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/responsive.dart';

class MenuItems extends StatelessWidget {

  final int? selectedIndex;
  final Function onPressed;

  const MenuItems({Key? key, this.selectedIndex = 0, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: _buildMobile(context), desktop: _buildDesktop(context));
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
              const SizedBox(height: 20,),
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
              const SizedBox(height: 10,),
              _loginWidget(context, onPressed: () {
                onPressed(4);
              }),
              const SizedBox(height: 10,),
              _getStartedWidget(context, onPressed: () {
                onPressed(4);
              })
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
          _loginWidget(context, onPressed: () {
            onPressed(4);
          }),
          _getStartedWidget(context, onPressed: () {
            onPressed(4);
          })
        ],
      ),
    );
  }

  Widget _getStartedWidget(BuildContext context, {required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
          ),
          onPressed: onPressed, child: Text('Get Started', style: Theme.of(context)
        .textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600),)),
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
            const SizedBox(width: 5,),
            Text('Login', style: Theme.of(context)
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
            backgroundColor: MaterialStateProperty.all(
              selectedIndex == index ? Colors.black12 : Colors.transparent
            )
          ),
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
