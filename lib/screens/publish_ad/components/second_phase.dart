import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/ad_model.dart';
import 'package:fly_ads_demo1/utils/auth_helper.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/dashed_rect.dart';
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

  bool loading = false;

  void _getUrl() {
    log('HEY');

    if (_selectedFile == null) {
      return;
    }

    log('TEST: ' + _selectedFile!.mimeType!.toString());
    final blob =
        html.Blob([_selectedFile!.readAsBytes()], _selectedFile!.mimeType!);
    videoUrl = html.Url.createObjectUrlFromBlob(blob);
    setState(() {});
  }

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
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          _selectedFile = await picker.pickVideo(
                              source: ImageSource.gallery);
                          setState(() {});
                          _getUrl();
                          log('TYPE: ' + _selectedFile!.mimeType.toString());
                        },
                        child: _selectFileWidget('Video'),
                      ),
                    ),
                  ],
                )
              : _selectedFile!.mimeType == 'video/mp4'
                  ? videoUrl == null
                      ? Utils.circularLoadingWidget()
                      : Center(
                          child: Text(
                            'Video Selected',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        )
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
                        loading = true;

                        AdModel adModel = widget.adModel;
                        adModel.userId = AuthenticationHelper().user!.uid;
                        adModel.fileUrl = sampleImageFile;

                        double amount = await _getTotalPrice();
                        adModel.price = amount;

                        log('PRICE: ' + amount.toString());

                        // await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const RazorPayWeb()));

                        // var authn = 'Basic ' +
                        //     base64Encode(
                        //         utf8.encode('$razorPayKey:$razorPaySecretKey'));
                        //
                        // var headers = {
                        //   'content-type': 'application/json',
                        //   'Authorization': authn,
                        // };
                        //
                        // var data = {
                        //   "amount": amount * 100,
                        //   "currency": "INR",
                        //   "receipt": "receipt#R1",
                        //   "payment_capture": 1
                        // };
                        //
                        // var res = await http.post(
                        //     Uri.parse('https://api.razorpay.com/v1/orders'),
                        //     headers: headers,
                        //     body: jsonEncode(data));
                        //
                        // if (res.statusCode != 200) {
                        //   log('Error: ${json.decode(res.body)['status'].toString()}');
                        // }

                        db
                            .collection('ads')
                            .add(adModel.toMap())
                            .then((value) async {
                          loading = false;
                          setState(() {});
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Ad Uploaded to Cloud'),
                                    content: const Text(
                                      'Your AD has been uploaded to cloud and will be published in less than a minute. Please check the status in Dashboard',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Dismiss'))
                                    ],
                                  ));
                          Navigator.of(context).pop();
                          return null;
                        });
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
