import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/ad_model.dart';
import 'package:fly_ads_demo1/screens/ad_details/ad_details.dart';
import 'package:fly_ads_demo1/screens/dashboard/dashboard_screen.dart';
import 'package:fly_ads_demo1/screens/publish_ad/publish_ad.dart';
import 'package:fly_ads_demo1/utils/auth_helper.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/responsive.dart';
import 'package:fly_ads_demo1/utils/utils.dart';
import 'package:intl/intl.dart';

class FlyAdsDashboard extends StatefulWidget {
  const FlyAdsDashboard({Key? key}) : super(key: key);

  @override
  State<FlyAdsDashboard> createState() => _FlyAdsDashboardState();
}

class _FlyAdsDashboardState extends State<FlyAdsDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20, // Your Height
              width: 20, // Your width
              child: IconButton(
                // Your drawer Icon
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()));
                },
                icon: const Icon(Icons.chevron_left, color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Flexible(
                child: Text(
              'FlyAds Dashboard',
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PublishAd()));
              },
              icon: const Icon(Icons.add_to_queue_outlined)),
          const SizedBox(
            width: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Hello, ' + AuthenticationHelper().user!.displayName.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db
            .collection('ads')
            .where('user_id', isEqualTo: AuthenticationHelper().user!.uid)
            .orderBy('created_on', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Utils.messageWidget(context, msg: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Utils.messageWidget(context,
                          msg: 'No Ads Found, Try Creating an AD',
                          useScaffold: false),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PublishAd()));
                          },
                          child: const Text('Create AD'))
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isDesktop(context) ||
                          Responsive.isTablet(context)
                      ? 2
                      : 1,
                  childAspectRatio: Responsive.isDesktop(context)
                      ? 2.2
                      : Responsive.isMobile(context)
                          ? 1.2
                          : Responsive.isMobileLarge(context)
                              ? 0.6
                              : 1),
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                AdModel adModel = AdModel.fromSnap(snapshot.data!.docs[index]);

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AdDetails(adModel: adModel)));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(-2, 2),
                              blurRadius: 20)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(adModel.campaignName),
                            subtitle: const Text('Campaign Name'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(adModel.adStatus!.name),
                            subtitle: const Text('AD Status'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Published On: ' +
                              DateFormat('dd MMM yyyy, h:mm a')
                                  .format(adModel.createdOn!.toDate())
                                  .toString(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                            'Last Modified On: ' +
                                DateFormat('dd MMM yyyy, h:mm a')
                                    .format(adModel.lastModifiedOn!.toDate())
                                    .toString(),
                            style: Theme.of(context).textTheme.caption),
                        const SizedBox(
                          height: 20,
                        ),
                        Responsive(
                            mobile: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _actionWidget(adModel),
                            ),
                            desktop: Row(
                              children: _actionWidget(adModel),
                            ))
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Utils.circularLoadingWidget();
        },
      ),
    ));
  }

  List<Widget> _actionWidget(AdModel adModel) {
    return [
      if (adModel.adStatus == ADStatus.Created &&
          adModel.paymentStatus == PaymentStatus.Pending) ...[
        ElevatedButton(
            onPressed: () {},
            child: const Text(
              'Complete Payment',
              textAlign: TextAlign.start,
            )),
        const SizedBox(
          width: 20,
          height: 10,
        ),
      ],
      ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Edit',
            textAlign: TextAlign.start,
          )),
      const SizedBox(
        width: 20,
        height: 10,
      ),
      ElevatedButton(
          onPressed: adModel.adStatus == ADStatus.Created ||
                  adModel.paymentStatus == PaymentStatus.Pending
              ? null
              : () {},
          child: const Text('View Analytics', textAlign: TextAlign.start))
    ];
  }
}
