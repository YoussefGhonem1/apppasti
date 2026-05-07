import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../dialogs.dart';

Future<XFile?> pickImage(context, int type) async {
  if (type == 1) {
    final ImagePicker _picker = ImagePicker();
    var status = await Permission.camera.request();

    if (status.isGranted) {
      return await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 50);
    } else {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        return await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 50);
      } else {
        showSnackBar(
            context, 'Si prega di consentire l`accesso alla fotocamera');
      }
    }
    return null;
  } else {
    final ImagePicker _picker = ImagePicker();
    var status = await Permission.photos.status;
    if (status.isGranted) {
      return await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
    } else {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        return await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);
      } else {
        showSnackBar(
            context, 'Si prega di consentire l`accesso alla fotocamera');
      }
    }
    return null;
  }
}

Future<XFile?> pickVideo(context, int type) async {
  if (type == 1) {
    final ImagePicker _picker = ImagePicker();
    var status = await Permission.camera.request();

    if (status.isGranted) {
      return await _picker.pickVideo(
          source: ImageSource.camera, maxDuration: Duration(seconds: 30));
    } else {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        return await _picker.pickVideo(
            source: ImageSource.camera, maxDuration: Duration(seconds: 30));
      } else {
        showSnackBar(
            context, 'Si prega di consentire l`accesso alla fotocamera');
      }
    }
    return null;
  } else {
    final ImagePicker _picker = ImagePicker();
    var status = await Permission.photos.status;
    if (status.isGranted) {
      return await _picker.pickVideo(
          source: ImageSource.gallery, maxDuration: Duration(seconds: 30));
    } else {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        return await _picker.pickVideo(
            source: ImageSource.gallery, maxDuration: Duration(seconds: 30));
      } else {
        showSnackBar(
            context, 'Si prega di consentire l`accesso alla fotocamera');
      }
    }
    return null;
  }
}
