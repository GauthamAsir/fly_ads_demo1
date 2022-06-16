// import 'dart:developer';
// import 'dart:html';
//
// import 'package:flutter/material.dart';
//
// //conditional import
// import 'package:fly_ads_demo1/utils/UiFake.dart'
//     if (dart.library.html) 'dart:ui' as ui;
//
// class RazorPayWeb extends StatelessWidget {
//   const RazorPayWeb({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     //register view factory
//     ui.platformViewRegistry.registerViewFactory("rzp-html", (int viewId) {
//       IFrameElement element = IFrameElement();
// //Event Listener
//       window.onMessage.forEach((element) {
//         log('Event Received in callback: ${element.data}');
//         if (element.data == 'MODAL_CLOSED') {
//           Navigator.pop(context);
//         } else if (element.data == 'SUCCESS') {
//           log('PAYMENT SUCCESSFUL!!!!!!!');
//         }
//       });
//
//       element.requestFullscreen();
//       element.src = 'assets/html/payment.html';
//       element.style.border = 'none';
//       return element;
//     });
//     return Scaffold(body: Builder(builder: (BuildContext context) {
//       return const HtmlElementView(viewType: 'rzp-html');
//     }));
//   }
// }
