import 'package:flutter/material.dart';
import 'package:pasti/constants/var.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/models/student.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/theme.dart';
import '../../../shared/dialogs.dart';

class StudentEditProfile extends StatefulWidget {
  final Student student;
  const StudentEditProfile({required this.student, Key? key}) : super(key: key);

  @override
  State<StudentEditProfile> createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  List<Map<String, String>> list = [
    {"title": "Nome", "image": "assets/person_icon.png"},
    {"title": "Cognome", "image": "assets/person_icon.png"},
    {"title": "N. personale", "image": "assets/person_icon.png"},
    {"title": "Nome utente", "image": "assets/person_icon.png"},
  ];

  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> list1 =
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> list2 = List.generate(4, (index) => FocusNode());
  bool _isSubmitting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with current student data
    list1[0].text = widget.student.name;
    list1[1].text = widget.student.lastName;
    list1[2].text = widget.student.personalId;
    list1[3].text = widget.student
        .name; // Username - you might want to get this from a different source
  }

  @override
  void dispose() {
    for (var controller in list1) {
      controller.dispose();
    }
    for (var node in list2) {
      node.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: mainColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Modifica Profilo',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),

                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainColor.withValues(alpha: 0.1),
                          secColor.withValues(alpha: 0.1)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: mainColor.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: mainColor,
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                'Modifica le tue informazioni personali',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: mainColor, size: 16),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  'Aggiorna i tuoi dati e salva le modifiche',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Form Fields
                  Column(
                    children: List.generate(list.length, (i) {
                      return _buildTextField(i, isDarkMode);
                    }),
                  ),

                  SizedBox(height: 6.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                setState(() => _isSubmitting = true);

                                // TODO: Implement update student profile function
                                await Future.delayed(Duration(
                                    seconds: 2)); // Simulating API call

                                setState(() => _isSubmitting = false);

                                // Update the global student object
                                student.name = list1[0].text;
                                student.lastName = list1[1].text;
                                student.personalId = list1[2].text;

                                successDialog(context,
                                    msg: 'Profilo aggiornato con successo!');
                                await Future.delayed(Duration(seconds: 1));
                                navPop(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: mainColor.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 18 : 16,
                        ),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_rounded, size: 20),
                                SizedBox(width: 2.w),
                                Text(
                                  'Salva Modifiche',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(int i, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with icon
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    list[i]['image']!,
                    width: 5.w,
                    color: mainColor,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                list[i]['title']!,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          // Text field
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black.withValues(alpha: 0.1),
            child: TextFormField(
              controller: list1[i],
              focusNode: list2[i],
              cursorColor: mainColor,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDarkMode ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                if (i != list2.length - 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Questo campo è obbligatorio';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: isDarkMode
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white,
                hintText: "Inserisci ${list[i]['title']?.toLowerCase()}",
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 2.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
