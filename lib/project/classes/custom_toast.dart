import 'package:controle_financeiro/project/classes/constants.dart';
import 'package:controle_financeiro/project/localization/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomToast extends StatelessWidget {
  final String message;

  const CustomToast(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        borderRadius: BorderRadius.circular(25.r),
        color: Color.fromRGBO(239, 247, 253, 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: blue3),
          SizedBox(width: 12.w),
          Text(
            getTranslated(context, message) ?? message,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

void customToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 60.h,
      left: 20.w,
      right: 20.w,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: CustomToast(message),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}