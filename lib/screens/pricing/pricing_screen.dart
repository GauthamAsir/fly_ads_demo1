import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/screens/membership_model.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/responsive.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({Key? key}) : super(key: key);

  static List<MembershipModel> membershipList = [
    MembershipModel(
        name: 'Free',
        duration: 3,
        price: 0.0,
        description: 'Sample Membership Description',
        shortDescription: '',
        benefits: {
          'Benefit 1 Sample': true,
          'Benefit 2 Sample': true,
          'Benefit 3 Sample': false,
          'Benefit 4 Sample': false,
        }),
    MembershipModel(
        name: 'Standard',
        duration: 6,
        price: 30.0,
        description: 'Sample Membership Description',
        shortDescription: '',
        benefits: {
          'Benefit 1 Sample': true,
          'Benefit 2 Sample': true,
          'Benefit 3 Sample': true,
          'Benefit 4 Sample': false,
        }),
    MembershipModel(
        name: 'Premium',
        duration: 12,
        price: 50.0,
        description: 'Sample Membership Description',
        shortDescription: '',
        benefits: {
          'Benefit 1 Sample': true,
          'Benefit 2 Sample': true,
          'Benefit 3 Sample': true,
          'Benefit 4 Sample': true
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.height / 2.5,
            color: secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Flexible(
                  child: FittedBox(
                    child: SelectableText('Explore Our Pricing Plans',
                        style: Responsive.isMobile(context)
                            ? Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black38.withOpacity(0.85),
                                overflow: TextOverflow.ellipsis)
                            : Responsive.isTablet(context)
                                ? Theme.of(context).textTheme.headline4!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black38.withOpacity(0.85),
                                    overflow: TextOverflow.ellipsis)
                                : Theme.of(context).textTheme.headline2!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black38.withOpacity(0.85),
                                    overflow: TextOverflow.ellipsis)),
                  ),
                ),
                const Flexible(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      'Some random sample text',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          AspectRatio(
            aspectRatio: Responsive.isDesktop(context)
                ? 2
                : Responsive.isMobile(context)
                    ? 0.6
                    : Responsive.isMobileLarge(context)
                        ? 0.9
                        : 1.4,
            child: Container(
              alignment: Alignment.center,
              child: ListView.builder(
                itemCount: membershipList.length,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => priceCard(context, index),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget priceCard(BuildContext context, int i) {
    MembershipModel membershipModel = membershipList[i];

    List<Map<String, bool>> benefitsList =
        membershipModel.benefits.entries.map((e) => {e.key: e.value}).toList();

    return AspectRatio(
      aspectRatio: 0.6,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 38),
                decoration: BoxDecoration(
                    color: appPrimaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        membershipModel.name,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '\$ ',
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis
                            ),
                          ),
                          Text(
                            membershipModel.price.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.headline3!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        membershipModel.description,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14, overflow: TextOverflow.ellipsis,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Valid for ' +
                            membershipModel.duration.toString() +
                            ' months',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14, overflow: TextOverflow.ellipsis,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                            child: Text(
                              'Get Started',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                  color: Colors.white, overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 38),
                decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: benefitsList.length,
                  itemBuilder: (context, index) {
                    Map<String, bool> item = benefitsList[index];

                    MapEntry e = item.entries.first;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            backgroundColor:
                                e.value ? Colors.green : Colors.red,
                            radius: 8,
                            child: Icon(
                              e.value
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(e.key),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
