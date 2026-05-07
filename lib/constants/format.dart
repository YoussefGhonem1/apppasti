

import 'package:flutter/services.dart';

FilteringTextInputFormatter allFiltering =
FilteringTextInputFormatter.allow(RegExp(r"[0-9 a-z A-Z ء-ي @ .]"));
FilteringTextInputFormatter englishFiltering =
FilteringTextInputFormatter.allow(RegExp(r"[0-9 a-z A-Z @ .]"));