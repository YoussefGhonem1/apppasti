// import 'package:pasti/constants/theme.dart';
// import 'package:pasti/helper_functions/translate.dart';
// import 'package:pasti/shared/size.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// class Net extends StatelessWidget {
//   const Net({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   elevation: 0,
//       //   title: Text(translate(context,'net','title'),style: TextStyle(color: Colors.white,fontSize: w*0.04),),
//       //   centerTitle: true,
//       //   backgroundColor: mainColor,
//       //   automaticallyImplyLeading: false,
//       // ),
//       body: WillPopScope(
//         onWillPop: ()async{
//           return false;
//         },
//         child: Container(
//           width: 100.w,
//           height: 100.h,
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(height: 25.h,),
//                 SizedBox(
//                   width: 40.w,
//                   height: 27.h,
//                   child: Image.asset('assets/nowifi.png',
//                   fit: BoxFit.contain,color: mainColor,),
//                 ),
//                 SizedBox(height: 1.h,),
//                 Text(translate(context,'net','no'),style: TextStyle(color: textColor(),fontSize: 14.sp),),
//                 SizedBox(height: 1.h,),
//                 Text(translate(context,'net','cut'),style: TextStyle(color: Colors.grey[400],fontSize: 12.sp),),
//                 SizedBox(height: 1.h,),
//                 Text(translate(context,'net','sure'),style: TextStyle(color: Colors.grey[400],fontSize: 12.sp),),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
