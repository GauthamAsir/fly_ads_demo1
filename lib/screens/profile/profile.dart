import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/screens/dashboard/dashboard_screen.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        return true;
      },
      child: SafeArea(
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
              const Text('Profile')
            ],
          ),
        ),
        body: Center(
          child: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      )),
    );
  }
}
