import 'package:flutter/material.dart';

const Color light = const Color(0xFFF7F8FC);
const Color lightGray = const Color(0xFFA4A6B3);
const Color dark = const Color(0xFF363740);
const Color active = const Color(0xFF0b57d0);

const Color primarycolor = const Color(0xFF0056D2);
//Color primarycolor = const Color(0xFF572ac8);
//Color primarycolor = const Color(0xFF2253E6);
const Color primarylightcolor = const Color(0xFF1e4ce0);
const Color secondarycolor = const Color(0xFFfed636);
const Color onprimary = const Color(0xFFF7F7FF);
const Color tertiarycolor = const Color(0xFFffe54a);

const Color redcolor = const Color(0xFFFF0000);

const Color graylight = const Color(0xFFbfbfbf);
const Color gray = const Color(0xFF7f7f7f);
const Color graydark = const Color(0xFF787878);
const Color graychatbg = const Color(0xFFF0F0F0);

//TYL
const Color graytext = const Color(0xFF64748B);
const Color blacktext = const Color(0xFF0F172A);
const Color lightwhitetext = const Color(0xFFFCFCFD);
const Color lightbluetext = const Color(0xFFE2EBFF);
const Color lightgreytext = const Color(0xFFE2E8F0);
const Color lightgreytext2 = const Color(0xFFCBD5E1);
const Color progressColor = const Color(0xFFFAB44C);
const Color progressColorLight = const Color(0xFFFDC573);
const Color lightGrayBg = const Color(0xFFF4F4F4);
const Color lightGraytext = const Color(0xFF797979);

const Color primaryBlue = Color(0xff2972ff);
const Color textBlack = Color(0xff222222);
const Color textGrey = Color(0xff94959b);
const Color textWhiteGrey = Color(0xfff1f1f5);
const Color textWhite = Color(0xffffffff);

Color spcard1 = const Color(0xFF2463EB);
Color spcard2 = const Color(0xFF17A34A);
Color spcard3 = const Color(0xFF9334E9);
Color spcard4 = const Color(0xFFEA580B);

Color shimmerBaseColor = const Color(0xFFC9D9FF); // Light blue (more visible)
Color shimmerHighlightColor = const Color(
  0xFFDDE7FF,
); // Softer highlight (still bright)

Color shimmerBaseColor2 = graylight.withAlpha(100);
Color shimmerHighlightColor2 = lightGrayBg;

Color blackmedium = const Color(0xFF404040);
Color lightblue = const Color(0xFFEAEFFF);
Color lightblue2 = const Color(0xFFF3F8FF);
Color lightblue3 = const Color(0xFFE7EDFF);
Color lightblue4 = primarycolor.withOpacity(0.15);
Color lightpink = const Color(0xFFFED6FF);
Color bordercolor = const Color(0xFFD8DADC);

Color lightwhite1 = const Color(0xFFFFFFFF7);
Color lightwhite2 = const Color(0xFFF7F7FF);
Color lightwhite3 = const Color(0xFFFFFAEF);
Color lightwhite4 = const Color(0xFFf3f2ed);
const Color whitecolor = const Color(0xFFFFFFFF);
Color blackcolor = const Color(0xFF000000);

//white light
Color bgccolor1 = const Color(0xFFffffff);
Color bgccolor2 = const Color(0xFFF3F8FF);

//Color bgccolor2 = const Color(0xFFf8fafd);
// blue lightblue
Color bgccolor3 = const Color(0xFFd3e3fd);
Color bgccolor4 = const Color(0xFF226dd4);

//gray gray light
Color bgccolor5 = const Color(0xFFe8eaed);
Color bgccolor6 = const Color(0xFF70757a);

Color textcolor = const Color(0xFF000000);
Color textcol_light = const Color(0xFF787878);
Color textcol_medium = const Color(0xFF2E2E2E);
Color textcol_dark = const Color(0xFF000000);

Color violetcolor = const Color(0xFF3D42DF);
Color goldencolor = const Color(0xFFFEC53D);
Color greenlightcolor = const Color(0xFF00B69B);

Color cardcolor1 = const Color(0xFF2ea7c4);
Color cardcolor2 = const Color(0xFFf44879);
Color cardcolor3 = const Color(0xFF32c1a4);
Color cardcolor4 = const Color(0xFFfabc1c);

Gradient homeGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff6DC2C6), // Top color
    Color(0xff0069AC), // Bottom color
  ],
);




final List<Gradient> gradiantList = [
  LinearGradient(
    colors: [Color(0xff1ed9bf), Color(0xff04a38d)], // Mint to Sky
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xff52b4f0), Color(0xff108ad3)], // Beige Sunset
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),

  LinearGradient(
    colors: [Color(0xff8e98f2), Color(0xff5e68b8)], // Soft Peach
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xffff9a63), Color(0xfff87049)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xff5C9602), Color(0xff8DC900)], // Green Gradient
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xff0B7ED7), Color(0xff069CDD)], // Blue Gradient
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),

  LinearGradient(
    colors: [Color(0xff9962DE), Color(0xff948DFF)], // Purple Gradient
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xff3A9F9F), Color(0xff00D5AA)], // Teal Gradient
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xffFFB75E), Color(0xffED8F03)], // Orange Gradient
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xffFF6A88), Color(0xffFF99AC)], // Pink Gradient
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Color(0xff7F7FD5), Color(0xff86A8E7)], // Soft Indigo Gradient
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
];

Gradient getGradientByIndex(int index) {  
  final int mappedIndex = (index % 10) % gradiantList.length;

  // Use defaultGradient if out of range or list is empty
  if (gradiantList.isEmpty || mappedIndex >= gradiantList.length) {
    return homeGradient;
  }

  return gradiantList[mappedIndex];
}
