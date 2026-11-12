import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2E7D32);

String setFontSize(FontWeight size) {
  if (size == FontWeight.w500 || size == FontWeight.w600) {
    return 'GothamProMed';
  } else if (size == FontWeight.w700 ||
      size == FontWeight.w800 ||
      size == FontWeight.w900 ||
      size == FontWeight.bold) {
    return 'GothamProBold';
  } else {
    return 'GothamPro';
  }
}
