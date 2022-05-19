import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/screens/fly_dashboard/fly_ads_dashboard.dart';

class DummyPayment extends StatefulWidget {
  const DummyPayment({Key? key}) : super(key: key);

  @override
  State<DummyPayment> createState() => _DummyPaymentState();
}

class _DummyPaymentState extends State<DummyPayment> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FlyAdsDashboard()));
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        body: Center(
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FlyAdsDashboard()));
                  },
                  child: const Text('Failure')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FlyAdsDashboard()));
                  },
                  child: const Text('Failure')),
            ],
          ),
        ),
      )),
    );
  }
}
