import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/utils.dart';

import 'screens/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initFirebase = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCwh6mQH0E97oUoT3SLlsane1YvIs42q_E",
          authDomain: "fly-ads.firebaseapp.com",
          projectId: "fly-ads",
          storageBucket: "fly-ads.appspot.com",
          messagingSenderId: "6428699133",
          appId: "1:6428699133:web:0c6d15e49eabf82dd1d194",
          measurementId: "G-XJXEWCF1E1"));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: appPrimaryColor,
      ),
      // home: PaymentHistory(
      //     adModel: AdModel(
      //         campaignName: 'campaignName',
      //         areaIDs: [0],
      //         startDate: Timestamp.now(),
      //         endDate: Timestamp.now(),
      //         price: 10,
      //         screenCount: 1250)),

      home: FutureBuilder(
        future: _initFirebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Utils.messageWidget(context,
                msg: (snapshot.error ?? '').toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // return PaymentHistory(
            //     adModel: AdModel(
            //         campaignName: 'campaignName',
            //         areaIDs: [0],
            //         startDate: Timestamp.now(),
            //         endDate: Timestamp.now(),
            //         price: 10,
            //         screenCount: 1250));

            return const Dashboard();
          }
          return const Scaffold(
            body: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
