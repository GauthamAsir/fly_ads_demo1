import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/ad_model.dart';
import 'package:fly_ads_demo1/screens/payment/payment_summary.dart';
import 'package:fly_ads_demo1/utils/auth_helper.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/dashed_rect.dart';
import 'package:fly_ads_demo1/utils/my_video_player.dart';
import 'package:fly_ads_demo1/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class SecondPhase extends StatefulWidget {
  final AdModel adModel;

  const SecondPhase({Key? key, required this.adModel}) : super(key: key);

  @override
  State<SecondPhase> createState() => _SecondPhaseState();
}

class _SecondPhaseState extends State<SecondPhase> {
  XFile? _selectedFile;
  Uint8List? imageUrl;
  dynamic videoUrl;

  Future<double> _getTotalPrice() async {
    AdModel adModel = widget.adModel;

    DocumentSnapshot<Map<String, dynamic>> docs =
        await db.collection('configs').doc('pricing').get();

    double adPrice = docs.data()!.isNotEmpty ? docs.data()!['ad_pricing'] : 0.0;

    int days = adModel.endDate.compareTo(adModel.startDate);
    log('Screen Count: ' + adModel.screenCount.toString());
    log('Days: ' + days.toString());

    return Future.value(adModel.screenCount * (adPrice * days));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          widget.adModel.campaignName,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 40,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _selectedFile == null
              ? Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          _selectedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {});
                          _getImageUrl();
                        },
                        child: _selectFileWidget('Image'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text('OR'),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          _selectedFile = await picker.pickVideo(
                              source: ImageSource.gallery);
                          setState(() {});
                          log('TYPE: ' + _selectedFile!.mimeType.toString());
                        },
                        child: _selectFileWidget('Video'),
                      ),
                    ),
                  ],
                )
              : _selectedFile!.mimeType == 'video/mp4'
                  ? MyVideoPlayer(path: _selectedFile!.path)
                  : imageUrl == null
                      ? Utils.circularLoadingWidget()
                      : AspectRatio(
                          aspectRatio: 5, child: Image.memory(imageUrl!)),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _selectedFile == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: primaryColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          'Video/Image will be processed in our server to check for any explicit content, signs or any words/characters against our policy.',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: Column(
            children: [
              FutureBuilder(
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    return Text(
                      snapshot.data!.toString() + 'Rs.',
                      style: Theme.of(context).textTheme.headline6,
                    );
                  },
                  future: _getTotalPrice()),
              ElevatedButton(
                onPressed: _selectedFile == null
                    ? null
                    : () async {
                  AdModel adModel = widget.adModel;
                        adModel.userId = AuthenticationHelper().user!.uid;
                        adModel.fileUrl = sampleImageFile;

                        double amount = await _getTotalPrice();
                        adModel.price = amount;
                        adModel.mimeType = _selectedFile!.mimeType;
                        adModel.fileUrl = _selectedFile!.path;

                        log('PRICE: ' + amount.toString());

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PaymentHistory(
                                  adModel: adModel,
                                  file: _selectedFile!,
                                )));
                      },
                child: Text(
                  'Make Payment & Publish',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _getImageUrl() async {
    var s = await _selectedFile!.readAsBytes();
    setState(() {
      imageUrl = s;
    });
  }

  Widget _selectFileWidget(String text) {
    return SizedBox(
      height: 120,
      child: DashedRect(
        color: primaryColor,
        strokeWidth: 2.0,
        gap: 3.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image,
              color: Colors.black45,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Select $text File',
              style: Theme.of(context).textTheme.subtitle2,
            )
          ],
        ),
      ),
    );
  }
}
