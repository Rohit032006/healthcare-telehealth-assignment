import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();
  static const Color bgColor = Color(0xFFEFF1F3);
  static const Color transparent = Colors.transparent;
  static const Color primaryColor = Color(0xff816AFF);
  static const Color black = Color(0XFF000000);
  static const Color hintTextColor = Color(0XFFBFBFBF);
  static const Color white = Colors.white;
  static const Color blue = Color(0xFF2196F3);
  static const Color whiteLight = Color.fromARGB(97, 194, 185, 185);
  static const Color purpul = Color.fromARGB(255, 77, 4, 160);
  static const Color teal = Colors.teal;
  static const Color pink = Colors.pink;
  static const Color buttonBlueDark = Color(0xff1677FF);
  static const Color selectedBtnColor = Color(0xFF7359FF);
  static const Color darkGreyColor = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF575454);
  static const Color greenBtnColor = Color(0xFFB7E024);
  static const Color indigo = Colors.indigo;
  static const Color orange = Colors.orange;
  static const Color lightGreen = Color.fromARGB(255, 144, 238, 144);
  static const Color textHeadingColor = Color(0xFF333333);
  static const Color greyTextColor = Color(0xFF616161);

  static const Color screenbgColor = Color.fromARGB(255, 245, 245, 245);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color parentBgColor = Color(0xFF0FBEB1);

  static const Color cultured = Color(0xffF5F5F5);

  static const Color lightGrey = Color(0XFFCCCCCC);
  static const Color redColorDark = Color(0xffFF3141);
  static const Color lightGreyColor = Color(0xFFD9D9D9);
  static const Color disabledForegroundColor = Color(0xffBCBCBC);
  static const Color disabledBackgroundColor = Color(0xffCCCCCC);
  static const Color orangeColor = Color(0xFFFF9228);
  static const Color blueColor = Color(0xFF3B82F6);

  static const Color blackColor = Color(0xFF000000);
  static const Color deepPurpleColor = Color(0xFF150B3D);
  static const Color mintGreenColor = Color(0xFFBBF7D0);
  static const Color iceBlueColor = Color(0xFFDBEAFE);
  static const Color teelBlueColor = Color(0xFF475569);
  static const Color yellowColor = Color(0xFFFDE047);
  static const Color redColor = Color(0xFFA90000);
  static const Color skyBlueColor = Color(0xFFEDF2FE);
  static const Color greenColor = Color(0xFF16A34A);
  static const Color darkBlueColor = Color(0xFF1E3A8A);
  static const Color lightCyanColor = Color(0xFFCFFAFE);
  static const Color brushOranageColor = Color(0xFFBC5A1E);
  static const Color textfieldColor = Color(0xFF373EA8);

  //snackbar colors
  static const Color successToastBgColor1 = Color(0Xff00B578);
  static const Color errorToastBgColor1 = Color(0xffFF3141);
  static const Color warningToastBgColor = Color(0xffFF8F1F);
  static const Color messageToastBgColor = Color(0xff1677FF);

  //snackbar bubbles Colors
  static const Color successBubbleColor = Color(0xff06704C);
  static const Color errorBubbleColor = Color(0xffC80313);
  static const Color warningBubbleColor = Color(0xffD66B00);
  static const Color messageBubbleColor = Color(0xff0251C1);
  static const Color treePoppy = Color(0xffFF9F18);
  static const Color hintOfGreen = Color(0xffF2FFF7);
  static const Color zirCon = Color(0xffF3F8FF);
  static const Color bridalHeath = Color(0xffFFF9F3);
  static const Color darkBlueColors = Color(0xFF131D38);

// app colors
  static const Color textGreyColor = Color(0xffADADAD);
  static const Color buttonBackgroundColor = Color(0xff2B2D38);
  static const Color bottomBarBackColor = Color(0xff353845);
  static const Color cardBackgroundColor = Color(0xff363843);
  static const Color backgroundColor = Color(0xFF2B2D38);
  static const Color outButtonColor = Color(0xffFFAF5F);

  // calendar color
  static const Color presentColor = Color(0xFFc6e1c6);
  static const Color absentColor = Color(0xFFeba3a3);
  static const Color pendingColor = Color(0xFFf8dda7);
  static const Color leavesColor = Color(0xFFc8d7e1);
  static const Color proposedholidayColor = Color(0xFF2789de);
  static const Color halfdayColor = Color(0xFFdfb3d7);
  static const Color rejectedColor = Color(0xFF2789de);
  static const Color regularizeColor = Color(0xffabcdff);
  static const Color halfleaveColor = Color(0xFF67b4b4);
  static const Color priorityHigh = Color(0xffEFA1A1);
  static const Color priorityCritical = Color(0xffC3C3C3);
  static const Color priorityMedium = Color(0xff7A44F5);
  static const Color priorityLow = Color(0xffE7F544);
  static const Color yellowColors = Color.fromARGB(255, 250, 246, 0);
  static const Color drawerBgColor = Color(0xff5C7113);

  // status color
  static const Color regularizationPendingColor = Color(0xffFFDC8E);
  static const Color divideColor = Color(0XFF484848);

  // shimmer
  static const Color shimmerBaseColor = Color(0xFF2A2D3E);
  static final Color shimmmerHighlightColor =
      const Color(0xFF0FBEB1).withValues(alpha: 0.3);
  static const Color shimmerGreyDark = Color(0xFF424242);
  static const Color breakButtonColor = Color(0xFFDF83F0);

  static const Color dateTextColor = Color(0XFF8D8D8D);

  // Light Theme Colors
  static const Color lightScaffoldBackgroundColor = Color(0xFFF4F7F9);
  static const Color lightCardColor = Colors.white;
  static const Color lightTextColor = Color(0xFF2B2D38);
  static const Color lightSubtitleColor = Color(0xFF616161);

  // Dark Theme Colors
  static const Color darkScaffoldBackgroundColor = Color(0xFF2B2D38);
  static const Color darkCardColor = Color(0xFF363843);
  static const Color darkTextColor = Colors.white;
  static const Color darkSubtitleColor = Color(0xFFADADAD);

  static const LinearGradient blackGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2B2D38),
      Color(0xFF131D38),
    ],
  );
  
  static const LinearGradient blackGradientDashbaord = LinearGradient(
    colors: [
      Color(0xFF000000),
      Color(0xFF454545),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
    static const Color revocationPendingColor = Color(0xFF6DFFDE);
  static const Color revokedColor = Color(0xFFF87171);

}
