import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynthiaTheme {
  ThemeData get theme {
    return ThemeData(
      primaryColor: const Color(0xffffffff),
      primaryColorLight: const Color(0xffffffff),
      accentColor: const Color(0xff2288ff),
      errorColor: const Color(0xffbE1d1d),
      fontFamily: GoogleFonts.ubuntu().fontFamily,
      textTheme: const TextTheme(
        subtitle1: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: Color(0xff3c3741),
        )
      )
    );
  }
}