//
// import '../../../constants/theme.dart';
// import '../../../helper_functions/loading.dart';
// import '../../../helper_functions/navigation.dart';
// import '../../../helper_functions/translate.dart';
// import '../../../main.dart';
// import '../../../shared/dialogs.dart';
// import '../../../shared/widgets/buttons.dart';
// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../constants/var.dart';
// import '../../helper_functions/shared_pref.dart';
// import '../../screens/auth/login/controller.dart';
// import '../screens/account/controller.dart';
//
// class SmsController extends ChangeNotifier{
//   late Timer  _timer;
//   String? verificationId;
//   int counter = 60;
//   bool dialogSms = false,makeError = false,finishSms = true,resend = false;
//   Future fireSms(context,{required String phone,
//     required void Function() function,String? token})async{
//     counter = 60;
//     List<TextEditingController> list1 = List.generate(6, (index) => TextEditingController());
//     List<FocusNode> list2 = List.generate(6, (index) => FocusNode());
//     try{
//       loading(context);
//       String ph = code+phone;
//
//       Future<PhoneVerificationFailed?> verificationFailed  (FirebaseAuthException authException)async{
//         resend = false;
//         navPop(context);
//         showSnackBar(context, 'Invio SMS non riuscito, attendere e riprovare');
//       }
//       Future<PhoneCodeAutoRetrievalTimeout?> autoTimeout  (String varId)async{
//         finishSms = true;
//         resend = false;
//         verificationId = varId;
//       }
//       await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: ph,
//           timeout: const Duration(seconds: 60),
//           verificationCompleted: (AuthCredential credential)async{
//             try{
//               var  result = await FirebaseAuth.instance.signInWithCredential(credential);
//               var ha = result.user;
//               if(ha!=null){
//
//                 function();
//                 print('hamza');
//               }
//             }catch(e)
//             {
//               navPop(context);
//               showSnackBar(context,'Il codice di verifica è errato');
//             }
//           },
//           verificationFailed: verificationFailed,
//           codeSent: (String verificationId,[int? forceResendingToken]){
//             resend = false;
//             finishSms = false;
//             if(dialogSms){
//               dialogSms = false;
//               navPop(context);
//             }
//             final _formKey2 = GlobalKey<FormState>();
//             navPop(context);
//             showModalBottomSheet(
//               context: context,
//               backgroundColor: Colors.white,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(36),
//                   topRight:  Radius.circular(36),
//                 ),
//               ),
//               builder: (context) {
//                 return Form(
//                   key: _formKey2,
//                   child: Padding(
//                     padding: MediaQuery.of(context).viewInsets,
//                     child: GestureDetector(
//                       onTap: (){
//                         FocusScope.of(context).unfocus();
//                       },
//                       child: Container(
//                         width: 100.w,
//                         constraints: BoxConstraints(
//                           maxHeight: isTablet?68.h:62.h,
//                           minHeight: isTablet?68.h:62.h,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(36),
//                             topRight:  Radius.circular(36),
//                           ),
//                         ),
//                         child: SingleChildScrollView(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 5.w),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 SizedBox(height: 3.h,),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: (30.w)/2),
//                                   child: Image.asset('assets/otp.png',fit: BoxFit.contain,width:
//                                   isTablet?30.w:45.w,),
//                                 ),
//                                 SizedBox(height: 2.h,),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: RichText(textAlign: TextAlign.center,text: TextSpan(
//                                       children: [
//                                         TextSpan(text: 'Abbiamo inviato un codice per verificare il numero di telefono ',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 13.sp,
//                                               color: Colors.black
//                                           ),
//                                         ),
//                                         TextSpan(text: '($code)'+phone,style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 13.sp,
//                                             color: mainColor
//                                         ),onEnter: (v){
//                                           print('hamza');
//                                         }),
//                                       ]
//                                   )),
//                                 ),
//                                 SizedBox(height: 2.h,),
//                                 FormField(
//                                   builder: (state){
//                                     return Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: 5.w),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: List.generate(6, (index) {
//                                               return SizedBox(
//                                                 width: 10.w,
//                                                 child: TextFormField(
//                                                   cursorColor: mainColor,
//                                                   focusNode: list2[index],
//                                                   controller: list1[index],
//                                                   style: TextStyle(fontSize: 11.sp,color: mainColor,),
//
//                                                   onChanged: (val){
//                                                     if(val.isNotEmpty){
//                                                       FocusScope.of(context).unfocus();
//                                                       if(index!=list2.length-1){
//                                                         FocusScope.of(context).nextFocus();
//                                                       }
//                                                     }
//                                                   },
//                                                   textAlign: TextAlign.center,
//                                                   decoration: InputDecoration(
//                                                     focusedBorder: UnderlineInputBorder(
//                                                       borderSide: BorderSide(color: mainColor),
//                                                     ),
//                                                   ),
//                                                   keyboardType: const TextInputType.numberWithOptions(),
//                                                 ),
//                                               );
//                                             }),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.symmetric(vertical: state.errorText!=null?1.h:0),
//                                           child: Align(
//                                             child: Text(
//                                               state.errorText ?? '',
//                                               style: TextStyle(
//                                                   color: Theme.of(context).errorColor,
//                                                   fontSize: 10.sp
//                                               ),
//                                             ),
//                                             alignment: Alignment.center,
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                   validator: (val){
//                                     if(makeError){
//                                       return 'Codice non VALIDO';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 SizedBox(height: 4.h,),
//                                 StatefulBuilder(
//                                   builder: (context2,setState3){
//                                     if(counter==60){
//                                       _timer = Timer.periodic(const Duration(seconds: 1), (e){
//                                         if(_timer.isActive){
//                                           setState3((){
//                                             counter--;
//                                           });
//                                         }
//                                         if(counter==0){
//                                           e.cancel();
//                                         }
//                                       });
//                                     }
//                                     return  Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 5.w),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           InkWell(
//                                             child: Text('Invia nuovamente il codice',style: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 10.sp,
//                                                 color: mainColor
//                                             ),),
//                                             onTap: (){
//                                               if(counter==0){
//                                                 if(!resend){
//                                                   resend = true;
//                                                   _timer.cancel();
//                                                   dialogSms = true;
//                                                   fireSms(context, phone: phone,
//                                                       function: function,token: token);
//                                                 }
//                                               }
//                                             },
//                                           ),
//                                           Text(counter.toString(),style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 10.sp,
//                                             color: Colors.black,
//                                           ),),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 SizedBox(height: 2.h,),
//                                 button1('Confermare',width: double.infinity,circular: 10,
//                                     onTap: ()async{
//                                       if (_formKey2.currentState!.validate()){
//                                         try{
//                                           loading(context);
//                                           FocusScope.of(context).unfocus();
//                                           String sms = '';
//                                           for(var l in list1){
//                                             sms += l.text;
//                                           }
//                                           AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: sms);
//                                           var  result = await FirebaseAuth.instance.signInWithCredential(credential);
//                                           navPop(context);
//                                           var ha = result.user;
//                                           if(ha!=null){
//                                             for(var l in list1){
//                                               l.clear();
//                                             }
//                                             _timer.cancel();
//                                             Navigator.pop(context,'done');
//                                           }
//                                         }catch(e){
//                                           navPop(context);
//                                           makeError = true;
//                                           if(_formKey2.currentState!.validate()){
//                                           }
//                                           makeError = false ;
//                                         }
//                                       }else{
//
//                                       }
//                                     }),
//                                 SizedBox(height: 2.h,),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               isScrollControlled: true,
//             )
//
//
//                 .then((value)async{
//               FocusScope.of(GlobalVariable.navState.currentContext!).unfocus();
//               if(value==null){
//                 logoutFunction(context,false,token);
//                 await prefs.setBool('login',false);
//                 await prefs.setInt('id',0);
//                 await prefs.setBool('isSchool',true);
//                 await prefs.setString('apiToken','');
//                 await prefs.setString('phone','');
//                 _timer.cancel();
//               }
//               if(value=='done'){
//                 function();
//                 print('hamza');
//               }
//             });
//           },
//           codeAutoRetrievalTimeout: autoTimeout);
//     }catch (e)
//     {
//       showSnackBar(context,'Il codice di verifica è errato');
//     }
//   }
// }