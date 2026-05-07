import 'package:flutter/material.dart';
import 'package:pasti/screens/splash_screen/controller.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplash(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 55.w,
                height: 25.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/app_icon.jpeg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 40.w,
                height: 45.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/hot_plate.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
