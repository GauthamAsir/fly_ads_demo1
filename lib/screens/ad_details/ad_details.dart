import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/ad_model.dart';
import 'package:fly_ads_demo1/utils/my_video_player.dart';

class AdDetails extends StatefulWidget {
  final AdModel adModel;

  const AdDetails({Key? key, required this.adModel}) : super(key: key);

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
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
            const Text('AD Detail')
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListTile(
              subtitle: const Text('Campaign Name'),
              title: Text(widget.adModel.campaignName),
            ),
            ListTile(
              subtitle: const Text('AD Status'),
              title: Text(widget.adModel.adStatus!.name),
            ),
            ListTile(
              title: const Text('Payment Status'),
              subtitle: Text(widget.adModel.paymentStatus!.name),
            ),
            ListTile(
              title: const Text('AD Status'),
              subtitle: Text(widget.adModel.adStatus!.name),
            ),
            widget.adModel.mimeType == 'video/mp4'
                ? MyVideoPlayer(path: widget.adModel.fileUrl!)
                : AspectRatio(
                    aspectRatio: 5,
                    child: Image.network(widget.adModel.fileUrl!))
          ],
        ),
      ),
    ));
  }
}
