import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/screens/auth/register/controller.dart';
import 'package:pasti/shared/dialogs.dart';
import 'package:pasti/shared/screens/account/controller.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/theme.dart';
import '../../../constants/var.dart';

class SchoolRegister extends StatefulWidget {
  final School? school;
  const SchoolRegister({this.school, Key? key}) : super(key: key);

  @override
  State<SchoolRegister> createState() => _SchoolRegisterState();
}

class _SchoolRegisterState extends State<SchoolRegister> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> list1 =
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> list2 = List.generate(4, (index) => FocusNode());
  XFile? img;

  List<Map<String, String>> list = [
    {"title": "Nome della Azienda", "image": "assets/school_icon.png"},
    {"title": "Nome utente", "image": "assets/person_icon.png"},
    {"title": "Password", "image": "assets/pass_icon.png"},
    {"title": "Sede", "image": "assets/location_icon.png"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.school != null) {
      list1.removeAt(2);
      list2.removeAt(2);
      list.removeAt(2);
      list1[0].text = widget.school!.name ?? '';
      list1[1].text = widget.school!.userName ?? "";
      list1[2].text = widget.school!.address ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
          appBar: appBar1(widget.school != null
              ? 'Modifica Azienda'
              : 'Registra la tua azienda'),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 3.h),

                  // Profile Image Section
                  _buildProfileImageSection(isDarkMode),

                  SizedBox(height: 4.h),

                  // Form Fields
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isDarkMode
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              ),
                            ],
                      border: Border.all(
                        color:
                            isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: List.generate(
                          list.length, (i) => _buildFormField(i, isDarkMode)),
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Submit Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          if (widget.school == null) {
                            schoolRegisterFunction(
                              context,
                              inputs: list1,
                              img: img == null ? null : File(img!.path),
                            );
                          } else {
                            schoolUpdateFunction(
                              context,
                              inputs: list1,
                              img: img == null ? null : File(img!.path),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shadowColor: mainColor.withValues(alpha: 0.3),
                      ),
                      child: Text(
                        widget.school != null
                            ? 'Conferma Modifiche'
                            : 'Registra Azienda',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(bool isDarkMode) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: isTablet ? 28.w : 40.w,
              height: isTablet ? 28.w : 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: mainColor.withValues(alpha: 0.3),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: img != null
                    ? Image.file(
                        File(img!.path),
                        fit: BoxFit.cover,
                      )
                    : widget.school != null &&
                            widget.school!.image?.isNotEmpty == true
                        ? Image.network(
                            widget.school!.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar(isDarkMode);
                            },
                          )
                        : _buildDefaultAvatar(isDarkMode),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  img = await chooseImage(context);
                  setState(() {});
                },
                child: Container(
                  width: isTablet ? 8.w : 12.w,
                  height: isTablet ? 8.w : 12.w,
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: isTablet ? 4.w : 6.w,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          widget.school != null
              ? 'Modifica immagine azienda'
              : 'Aggiungi logo azienda',
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Tocca l\'icona della fotocamera per modificare',
          style: TextStyle(
            color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mainColor, mainColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          widget.school != null ? Icons.business : Icons.add_business,
          color: Colors.white,
          size: 15.w,
        ),
      ),
    );
  }

  Widget _buildFormField(int index, bool isDarkMode) {
    final field = list[index];

    return Container(
      margin: EdgeInsets.only(bottom: index == list.length - 1 ? 0 : 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field Header
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _getFieldIcon(index),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  field['title']!,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Text Field
          TextFormField(
            cursorColor: mainColor,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            controller: list1[index],
            focusNode: list2[index],
            validator: (value) {
              if (index <= (widget.school != null ? 1 : 2) && value!.isEmpty) {
                return 'Questo campo è obbligatorio';
              }
              return null;
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              if (index != list2.length - 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            obscureText: index == 2 && widget.school == null,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
              hintText: field['title']!,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 11.sp,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: mainColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              suffixIcon: index == 2 && widget.school == null
                  ? IconButton(
                      icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFieldIcon(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.business, color: mainColor, size: 5.w);
      case 1:
        return Icon(Icons.person_outline, color: mainColor, size: 5.w);
      case 2:
        return Icon(Icons.lock_outline, color: mainColor, size: 5.w);
      case 3:
        return Icon(Icons.location_on_outlined, color: mainColor, size: 5.w);
      default:
        return Icon(Icons.edit, color: mainColor, size: 5.w);
    }
  }
}
