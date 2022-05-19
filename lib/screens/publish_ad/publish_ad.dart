import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/ad_model.dart';
import 'package:fly_ads_demo1/models/area_model.dart';
import 'package:fly_ads_demo1/screens/publish_ad/components/first_phase.dart';
import 'package:fly_ads_demo1/screens/publish_ad/components/second_phase.dart';
import 'package:fly_ads_demo1/utils/constants.dart';

class PublishAd extends StatefulWidget {
  const PublishAd({Key? key}) : super(key: key);

  @override
  State<PublishAd> createState() => _PublishAdState();
}

class _PublishAdState extends State<PublishAd> {
  List<AreaModel> areas = [];

  int phaseValue = 1;
  String? campaignName;

  AdModel? adModel;

  Future init() async {
    await db.collection('configs').doc('area').get().then((value) {
      if (value.data() == null) {
        return;
      }

      List<dynamic> l = value.data()!['area_list'];

      for (Map<String, dynamic> i in l) {
        areas.add(AreaModel.fromMap(i));
      }

      setState(() {});

      // log('Length: ' + areas.length.toString());

      return null;
    });

    log('List: ' + areas.length.toString());
  }

  @override
  void initState() {
    init();
    super.initState();
  }

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
                  Navigator.of(context).pop();
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const Dashboard()));
                },
                icon: const Icon(Icons.chevron_left, color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text('Publish AD')
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: getChild(),
          ),
        ),
      ),
    ));
  }

  Widget getChild() {
    switch (phaseValue) {
      case 1:
        return FirstPhasePublishAD(
            areas: areas,
            phaseCompleted: (AdModel adModel) {
              setState(() {
                this.adModel = adModel;
                phaseValue = 2;
              });
            });
      case 2:
        return SecondPhase(
          adModel: adModel!,
        );
      default:
        return Container();
    }
  }
}
