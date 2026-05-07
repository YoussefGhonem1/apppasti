import 'package:flutter/material.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/models/student.dart';
import 'package:pasti/screens/main_page/school/home/controller.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/theme.dart';
import '../../../../shared/screens/info/view.dart';
import '../../student/home/controller.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({Key? key}) : super(key: key);

  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  final TextEditingController controller = TextEditingController();

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
        appBar: appBar1('Collaboratori'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 2.h),

                // Header Card
                _buildHeaderCard(isDarkMode),

                SizedBox(height: 4.h),

                // Search Bar
                _buildSearchBar(isDarkMode),

                SizedBox(height: 3.h),

                // Students List
                if (studentList.isEmpty) _buildEmptyState(isDarkMode),
                if (studentList.isNotEmpty)
                  Column(
                    children: List.generate(studentList.length, (i) {
                      return _buildStudentCard(studentList[i], i, isDarkMode);
                    }),
                  ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: mainColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainColor, secColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Container(
                //       width: 14.w,
                //       height: 14.w,
                //       decoration: BoxDecoration(
                //         gradient: LinearGradient(
                //           colors: [mainColor, mainColor.withValues(alpha: 0.8)],
                //           begin: Alignment.topLeft,
                //           end: Alignment.bottomRight,
                //         ),
                //         borderRadius: BorderRadius.circular(14),
                //       ),
                //       child: Center(
                //         child: Icon(
                //           Icons.people_rounded,
                //           color: Colors.white,
                //           size: 6.w,
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 4.w),
                //     Text(
                //       'Tutti i Collaboratori',
                //       style: TextStyle(
                //         color: isDarkMode ? Colors.white : Colors.black,
                //         fontSize: 14.sp,
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        mainColor.withValues(alpha: 0.1),
                        mainColor.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: mainColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          students.toString(),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Collaboratori totali',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Gestisci tutti i collaboratori',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: TextFormField(
        cursorColor: mainColor,
        controller: controller,
        style: TextStyle(
          fontSize: 12.sp,
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor:
              isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          hintText: 'Cerca collaboratore...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 11.sp,
          ),
          prefixIcon: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              getStudentFunction(context, search: true, name: controller.text)
                  .then((value) {
                setState(() {});
              });
            },
            child: Container(
              width: 60,
              child: Row(
                children: [
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.search_rounded,
                    color: mainColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
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
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 3.h,
          ),
        ),
        onFieldSubmitted: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
          getStudentFunction(context, search: true, name: controller.text)
              .then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  Widget _buildStudentCard(Student student, int index, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await getOrdersFunction(context, fromSchool: true, id: student.id);
            navP(
              context,
              StudentInfo(
                id: student.id,
                name: student.name,
                fromSchool: true,
                student: student,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      student.name[0].toUpperCase(),
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${student.lastName} ${student.name}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'ID: ${student.personalId}',
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      height: 40.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.people_alt_rounded,
                  size: 15.w,
                  color: mainColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Nessun collaboratore trovato',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              controller.text.isNotEmpty
                  ? 'Nessun risultato per "${controller.text}"'
                  : 'I collaboratori appariranno qui',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
