import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final String sampleShortText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus viverra ante et arcu hendrerit suscipit. Phasellus posuere erat a purus mollis eleifend. Morbi ac vestibulum nisi, ut faucibus libero. Ut id feugiat lacus. Nam blandit dui ante.';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: Responsive.isDesktop(context) ? 120 : 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 10
                    : 32),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isMobile(context))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/sample_image.PNG',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.contain,
                        ),
                      ),
                    SizedBox(
                      width: Responsive.isTablet(context)
                          ? MediaQuery.of(context).size.width / 2.6
                          : MediaQuery.of(context).size.width,
                      child: Responsive(
                        desktop: Text(
                          'Communicate.\nCollaborate. Create.',
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                        tablet: Text(
                          'Communicate.\nCollaborate. Create.',
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                        mobileLarge: FittedBox(
                          child: Text(
                            'Communicate.\nCollaborate. Create.',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                          ),
                        ),
                        mobile: FittedBox(
                          child: Text(
                            'Communicate.\nCollaborate. Create.',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Responsive.isTablet(context)
                          ? MediaQuery.of(context).size.width / 2.6
                          : MediaQuery.of(context).size.width,
                      child: Text(
                        'Advertise your Brand on Digital Screen across cities!\nStart your Advertisement at 25₹',
                        style: Responsive.isDesktop(context)
                            ? Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.w400, color: Colors.black)
                            : Theme.of(context).textTheme.subtitle2!.copyWith(
                                fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16)),
                        child: Text(
                          'Get Started',
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    Responsive(
                        mobile: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _widget1(context,
                                iconData: Icons.security_rounded,
                                name: 'Security'),
                            const SizedBox(
                              height: 30,
                            ),
                            _widget1(context,
                                iconData: Icons.security_rounded,
                                name: 'Flexibility &\nScalability'),
                            const SizedBox(
                              height: 30,
                            ),
                            _widget1(context,
                                iconData: Icons.security_rounded,
                                name: 'Better\nCollaboration'),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        desktop: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _widget1(context,
                                iconData: Icons.security_rounded,
                                name: 'Security'),
                            const SizedBox(
                              width: 30,
                            ),
                            _widget1(context,
                                iconData: Icons.security_rounded,
                                name: 'Flexibility &\nScalability'),
                            const SizedBox(
                              width: 30,
                            ),
                            _widget1(context,
                                iconData: Icons.security_rounded,
                                name: 'Better\nCollaboration'),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        )),
                  ],
                ),
                if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                  Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/images/sample_image.PNG',
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        fit: BoxFit.contain,
                      )),
              ],
            ),
          ),
          SizedBox(
            height: Responsive.isDesktop(context) ? 120 : 20,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 10
                    : 32, vertical: MediaQuery.of(context).size.height / 10),
            decoration: BoxDecoration(color: appPrimaryColor),
            child: Responsive(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'With the Right Software, Great Things Can Happen',
                    maxLines: 10,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    sampleShortText,
                    maxLines: 10,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: 1.5,
                        height: 1.5),
                  )
                ],
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Text(
                      'With the Right Software, Great Things Can Happen',
                      maxLines: 10,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w500, color: Colors.black,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      sampleShortText,
                      maxLines: 10,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.w500, color: Colors.black,
                          overflow: TextOverflow.ellipsis, letterSpacing: 1.5, height: 1.5),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _widget1(BuildContext context,
      {required String name, required IconData iconData}) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.black),
              padding: const EdgeInsets.all(4),
              child: Icon(
                iconData,
                color: Colors.white,
              )),
          const SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black87),
          )
        ],
      ),
    );
  }
}
