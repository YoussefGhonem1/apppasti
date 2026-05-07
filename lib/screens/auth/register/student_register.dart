import 'package:flutter/material.dart';
import 'package:pasti/constants/var.dart';
import 'package:pasti/models/classes.dart';
import 'package:pasti/screens/auth/register/controller.dart';
import 'package:sizer/sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../constants/theme.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({Key? key}) : super(key: key);

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  List<Map<String, String>> list = [
    {"title": "Nome", "image": "assets/person_icon.png"},
    {"title": "Cognome", "image": "assets/person_icon.png"},
    {"title": "N. personale", "image": "assets/person_icon.png"},
    {"title": "Codice ID dell'azienda", "image": "assets/school_icon.png"},
    {"title": "Sede dell'azienda", "image": "assets/class_icon.png"},
    {"title": "Nome utente", "image": "assets/person_icon.png"},
    {"title": "Password", "image": "assets/pass_icon.png"},
  ];
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> list1 =
      List.generate(7, (index) => TextEditingController());
  List<FocusNode> list2 = List.generate(7, (index) => FocusNode());
  List<Classes> classes = [];
  String? className;
  int? classId;
  bool _isVerifying = false;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  final ScrollController _scrollController = ScrollController();

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
            'Registro Collaboratori',
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
                      color: mainColor.withValues(alpha: 0.1),
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
                                Icons.person_add_alt_1,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                'Completa tutti i campi per registrarti come collaboratore',
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
                        Text(
                          'Tutti i campi sono obbligatori',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Form Fields
                  Column(
                    children: List.generate(list.length, (i) {
                      // Special handling for dropdown (company location)
                      if (i == 4) {
                        return _buildDropdownField(i);
                      }

                      return _buildTextField(i, isDarkMode);
                    }),
                  ),

                  SizedBox(height: 6.h),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                if (classes.isNotEmpty) {
                                  FocusScope.of(context).unfocus();
                                  setState(() => _isSubmitting = true);
                                  await studentRegisterFunction(
                                    context,
                                    inputs: list1,
                                    classId: classId!,
                                  );
                                  setState(() => _isSubmitting = false);
                                } else {
                                  _showValidationError();
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
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
                          : Text(
                              'Registrati',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Additional Info
                  Center(
                    child: Text(
                      'Riceverai una mail di conferma una volta approvato',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
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
    final isPasswordField = i == 6;

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
              obscureText: isPasswordField ? _obscurePassword : false,
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
                if (i != 4 && value!.isEmpty) {
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
                suffixIcon: _buildSuffixIcon(i),
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

          // Helper text for specific fields
          if (i == 3)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                'Richiedi il codice ID all\'amministratore dell\'azienda',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon(int i) {
    if (i == 3) {
      return _isVerifying
          ? Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.verified, color: Colors.white, size: 18),
                onPressed: () async {
                  setState(() => _isVerifying = true);
                  List<Classes> cla = await getClassesRegister(
                    context,
                    code: list1[i].text,
                  );
                  setState(() => _isVerifying = false);

                  if (cla.isNotEmpty) {
                    classes = cla;
                    className = classes.first.className;
                    classId = classes.first.id;
                    setState(() {});

                    // Scroll to dropdown
                    _scrollController.animateTo(
                      400,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            );
    }

    if (i == 6) {
      return IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[500],
        ),
        onPressed: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
      );
    }

    return null;
  }

  Widget _buildDropdownField(int i) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

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

          // Dropdown
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black.withValues(alpha: 0.1),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonFormField2<String>(
                value: className,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: "Scegli la sede",
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 2.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: mainColor,
                      width: 1.5,
                    ),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: mainColor,
                    size: 24,
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  offset: const Offset(0, 10),
                ),
                menuItemStyleData: MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                isExpanded: true,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
                items: List.generate(classes.length, (index) {
                  return DropdownMenuItem<String>(
                    value: classes[index].className,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.2.h, horizontal: 0.5.w),
                      child: Row(
                        children: [
                          Icon(Icons.business, color: mainColor, size: 16),
                          SizedBox(width: 3.w),
                          Text(
                            classes[index].className,
                            style: TextStyle(
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      className = val;
                      classId = classes
                          .firstWhere((element) => element.className == val)
                          .id;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleziona una sede';
                  }
                  return null;
                },
              ),
            ),
          ),

          // Helper text for dropdown
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                SizedBox(width: 1.w),
                Text(
                  'Seleziona la sede più vicina a te',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Verifica prima il codice aziendale',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
