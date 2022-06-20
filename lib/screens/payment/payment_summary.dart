import 'dart:developer' as dev;
import 'dart:math';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/ad_model.dart';
import 'package:fly_ads_demo1/screens/dashboard/dashboard_screen.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/responsive.dart';
import 'package:image_picker/image_picker.dart';

class PaymentHistory extends StatefulWidget {
  final AdModel adModel;
  final XFile file;

  const PaymentHistory({
    Key? key,
    required this.adModel,
    required this.file,
  }) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  bool partPayment = false, downloadInvoice = true, loading = false;

  static const BoxDecoration boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
          offset: Offset(0, 8),
          color: Colors.black26,
          spreadRadius: 8,
          blurRadius: 4),
    ],
    color: Colors.white,
  );

  Future<double> getPrice() async {
    DocumentSnapshot<Map<String, dynamic>> docs =
        await db.collection('configs').doc('pricing').get();

    return docs.data()!.isNotEmpty ? docs.data()!['ad_pricing'] : 0.0;
  }

  Future<UploadTask> uploadFile() async {
    XFile file = widget.file;

    // if (file == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('No file was selected'),
    //     ),
    //   );
    //
    //   return null;
    // }

    UploadTask uploadTask;

    Random random = Random();
    int randomNumber = random.nextInt(100);

    // Create a Reference to the file
    // Using Random number so the same file name possibility will be much less (almost to no)
    Reference ref = FirebaseStorage.instance.ref().child('ads').child(
        '/FlyAds_${Timestamp.now().millisecondsSinceEpoch}_$randomNumber');

    final metadata = SettableMetadata(
      contentType: file.mimeType,
      customMetadata: {'picked-file-path': file.path},
    );

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    // if (kIsWeb) {
    //   uploadTask = ref.putData(await file.readAsBytes(), metadata);
    // }
    // else {
    //   uploadTask = ref.putFile(io.File(file.path), metadata);
    // }

    return Future.value(uploadTask);
  }

  Future<String> _downloadLink(Reference ref) async {
    return await ref.getDownloadURL();
  }

  /// Displays the current transferred bytes of the task.
  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${getFormattedSize(snapshot.bytesTransferred, 2)}/${getFormattedSize(snapshot.totalBytes, 2)}';
  }

  String getFormattedSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Future<void> uploadAD(AdModel adModel) async {
    loading = true;
    setState(() {});

    UploadTask task = await uploadFile();

    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: StreamBuilder<TaskSnapshot>(
                  stream: task.snapshotEvents,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<TaskSnapshot> asyncSnapshot,
                  ) {
                    Widget subtitle = const Text('---');
                    TaskSnapshot? snapshot = asyncSnapshot.data;
                    TaskState? state = snapshot?.state;

                    if (asyncSnapshot.hasError) {
                      if (asyncSnapshot.error is FirebaseException &&
                          // ignore: cast_nullable_to_non_nullable
                          (asyncSnapshot.error as FirebaseException).code ==
                              'canceled') {
                        subtitle = const Text('Upload canceled.');
                      } else {
                        // ignore: avoid_print
                        print(asyncSnapshot.error);
                        subtitle = const Text('Something went wrong.');
                      }
                    } else if (snapshot != null) {
                      subtitle = Text('${_bytesTransferred(snapshot)} sent');
                    }

                    if (state == TaskState.success) {
                      Navigator.of(context).pop();
                    }

                    return Dismissible(
                      key: Key(task.hashCode.toString()),
                      onDismissed: (value) {},
                      child: ListTile(
                        title: const Text('Uploading your file'),
                        subtitle: subtitle,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (state == TaskState.running)
                              IconButton(
                                icon: const Icon(Icons.pause),
                                onPressed: task.pause,
                              ),
                            if (state == TaskState.running)
                              IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: task.cancel,
                              ),
                            if (state == TaskState.paused)
                              IconButton(
                                icon: const Icon(Icons.file_upload),
                                onPressed: task.resume,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
            ));

    if (task.snapshot.state != TaskState.success) {
      dev.log('Something went wrong!!!');
      return;
    }

    adModel.fileUrl = await _downloadLink(task.snapshot.ref);
    adModel.adStatus = ADStatus.Active;

    db.collection('ads').add(adModel.toMap()).then((value) async {
      for (var element in adModel.areaIDs) {
        String docId = '';

        if (element == 01) {
          docId = 'Bhandup';
        } else if (element == 02) {
          docId = 'Sion';
        } else {
          docId = 'Matunga';
        }

        Map d = {
          'admin_status': 'active',
          'campaign_name': adModel.campaignName,
          'start_date': adModel.startDate.toDate().toString(),
          'end_date': adModel.endDate.toDate().toString(),
          'file_url': adModel.fileUrl,
          'payment': adModel.paymentStatus! == PaymentStatus.Success,
          'plan': 'normal',
          'uid': adModel.userId,
          'id': value.id
        };

        await db.collection('Mumbai').doc(docId).update({value.id: d});
      }

      loading = false;
      setState(() {});

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Ad Uploaded to Cloud'),
                content: Text(
                  '${adModel.paymentStatus! == PaymentStatus.Success ? 'Payment Success\n' : 'Payment Pending/Failed\nDont\'t worry.'}Your AD has been uploaded to cloud and will be processed in less than a minute. Please check the status in Dashboard',
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
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Dashboard()));
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Responsive(
              mobile: Container(
                height: constraints.maxHeight / 1.2,
                width: constraints.maxWidth / 1.2,
                decoration: boxDecoration,
                child: _getDetails(),
              ),
              tablet: Container(
                height: constraints.maxHeight / 1.2,
                width: constraints.maxWidth / 2,
                decoration: boxDecoration,
                child: _getDetails(),
              ),
              desktop: Container(
                height: constraints.maxHeight / 1.2,
                width: constraints.maxWidth / 2,
                decoration: boxDecoration,
                child: _getDetails(),
              )),
        ),
      ),
    );
  }

  Widget _getDetails() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(
          height: 20,
        ),
        Center(
            child: Text(
          'Payment Summary',
          style: Theme.of(context).textTheme.headline5,
        )),
        const SizedBox(
          height: 20,
        ),
        CheckboxListTile(
            value: partPayment,
            activeColor: Colors.amber[800],
            title: Text(
              'Part Payment',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('This is demo model (W.I.P)'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(milliseconds: 1500),
                ));
              }

              partPayment = value;
              setState(() {});
            }),
        const SizedBox(
          height: 20,
        ),
        CheckboxListTile(
            value: downloadInvoice,
            activeColor: Colors.amber[800],
            title: Text(
              'Download Invoice on Success Payment',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('This is demo model (W.I.P)'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(milliseconds: 1500),
                ));
              }

              downloadInvoice = value;
              setState(() {});
            }),
        const SizedBox(
          height: 20,
        ),
        ExpansionTile(
          title: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total Price for selected city/cities',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Expanded(
                child: Text(widget.adModel.price.toString() + ' Rs',
                    style: Theme.of(context).textTheme.subtitle1),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(flex: 2, child: Text('Per Screen')),
                      Expanded(
                          flex: 1,
                          child: FutureBuilder<double>(
                            future: getPrice(),
                            builder: (context, snap) {
                              return snap.hasError
                                  ? const Text('NA')
                                  : snap.hasData
                                      ? Text(
                                          '${snap.data} Rs',
                                          textAlign: TextAlign.start,
                                        )
                                      : const CircularProgressIndicator();
                            },
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(flex: 2, child: Text('Total Screens')),
                      Expanded(
                          flex: 1,
                          child: Text(widget.adModel.screenCount.toString())),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                          flex: 2,
                          child: Text('Total Price',
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(
                          flex: 1,
                          child: Text(widget.adModel.price.toString() + ' Rs',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600))),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  AdModel adModel = widget.adModel;
                  adModel.paymentStatus = PaymentStatus.Failed;

                  uploadAD(adModel);
                },
                child: const Text('Make Failure Payment')),
            ElevatedButton(
                onPressed: () async {
                  AdModel adModel = widget.adModel;
                  adModel.paymentStatus = PaymentStatus.Success;

                  uploadAD(adModel);
                },
                child: const Text('Make Success Payment')),
          ],
        )
      ],
    );
  }
}
