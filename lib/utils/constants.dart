import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFFFFC107);
const secondaryColor = Color(0xFFFFD7EF);
const darkColor = Color(0xFF191923);
const bodyTextColor = Color(0xFF8B8B8D);
const bgColor = Color(0xFF1E1E28);

const maxWidth = 1440.0; // max width of our web

Map<int, Color> swatchColor = {
  50: const Color.fromRGBO(255, 193, 7, .1),
  100: const Color.fromRGBO(255, 193, 7, .2),
  200: const Color.fromRGBO(255, 193, 7, .3),
  300: const Color.fromRGBO(255, 193, 7, .4),
  400: const Color.fromRGBO(255, 193, 7, .5),
  500: const Color.fromRGBO(255, 193, 7, .6),
  600: const Color.fromRGBO(255, 193, 7, .7),
  700: const Color.fromRGBO(255, 193, 7, .8),
  800: const Color.fromRGBO(255, 193, 7, .9),
  900: const Color.fromRGBO(255, 193, 7, 1),
};

MaterialColor appPrimaryColor = MaterialColor(0xFFFFC107, swatchColor);

FirebaseFirestore db = FirebaseFirestore.instance;

const String sampleImageFile =
    'https://www.learningcontainer.com/wp-content/uploads/2020/10/Sample-BMP-File-For-Testing.png';

const String razorPayKey = 'rzp_test_edxTb8Kkubkbb9';
const String razorPaySecretKey = 'qV0Fj7MCPo2LhvxTsgTYK1RY';