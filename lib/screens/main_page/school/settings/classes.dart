import 'package:flutter/material.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/models/classes.dart';
import 'package:pasti/shared/dialogs.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/theme.dart';

class ClassesPage extends StatefulWidget {
  final List<Classes> classes;
  const ClassesPage({required this.classes, Key? key}) : super(key: key);

  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  List<Classes> classes = [];

  @override
  void initState() {
    super.initState();
    classes = widget.classes;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: appBar1('Sedi'),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        icon: Icon(Icons.add_circle_outline, size: 20),
        label: Text(
          'Aggiungi Sede',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          Classes? check = await enterClass(context, null, null);
          if (check != null) {
            classes.add(check);
            setState(() {});
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: classes.isEmpty
            ? _buildEmptyState(isDarkMode)
            : RefreshIndicator(
                color: mainColor,
                backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 2.h),

                    // Header Card
                    _buildHeaderCard(isDarkMode),

                    SizedBox(height: 4.h),

                    // Classes List
                    ...List.generate(classes.length, (i) {
                      return _buildClassCard(classes[i], i, isDarkMode);
                    }),

                    SizedBox(height: 10.h), // Space for FAB
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDarkMode) {
    return Container(
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
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 60,
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
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [mainColor, mainColor.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'Gestione Sedi',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          classes.length.toString(),
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sedi registrate',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Gestisci le sedi della tua azienda',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildClassCard(Classes classItem, int index, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            // Index Badge
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [mainColor, secColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            SizedBox(width: 4.w),

            // Class Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business_rounded,
                        color: mainColor,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          classItem.className,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'ID: ${classItem.id}',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 2.w),

            // Action Buttons
            Column(
              children: [
                // Edit Button
                _buildActionButton(
                  icon: Icons.edit_rounded,
                  color: Colors.green,
                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                  onPressed: () async {
                    Classes? check = await enterClass(
                      context,
                      classItem.className,
                      classItem.id,
                    );
                    if (check != null) {
                      classes.removeAt(index);
                      classes.insert(index, check);
                      setState(() {});
                    }
                  },
                ),

                SizedBox(height: 1.5.h),

                // Delete Button
                _buildActionButton(
                  icon: Icons.delete_rounded,
                  color: Colors.red,
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  onPressed: () {
                    confirmDialog(
                      context,
                      'Confermare la cancellazione',
                      () async {
                        bool check = await Classes.deleteClass(classItem.id);
                        navPop(context);
                        if (check) {
                          classes.removeAt(index);
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 16),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
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
                Icons.business_outlined,
                size: 15.w,
                color: mainColor,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Nessuna sede registrata',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Aggiungi la prima sede per iniziare',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () async {
              Classes? check = await enterClass(context, null, null);
              if (check != null) {
                classes.add(check);
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.8.h),
            ),
            child: Text(
              'Aggiungi Sede',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
