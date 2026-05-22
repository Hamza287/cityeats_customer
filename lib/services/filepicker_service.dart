import 'package:city_customer_app/app/app.logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FilepickerService {
  final log = getLogger('FilePickerService');
  final FileType _pickingType = FileType.any;
  final ImagePicker imgpicker = ImagePicker();

  Future<List<PlatformFile>?> pickMultipleFiles() async {
    List<PlatformFile>? paths;
    try {
      paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => log.i(status),
      ))
          ?.files;
    } on PlatformException catch (e) {
      log.e('Unsupported operation $e');
    } catch (e) {
      log.e(e.toString());
    }

    return paths;
  }

  Future<List<XFile>?> pickMultiImages({
    int? imageQuality,
    double? maxHeight,
    double? maxWidth,
  }) async {
    var pickedfiles = await imgpicker.pickMultiImage(
      imageQuality: imageQuality,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    List<XFile>? imagefiles = [];

    try {
      // *YOU CAN USE CAMERA FOR IMAGES AS WELL
      if (pickedfiles.isNotEmpty) {
        if (imagefiles.isNotEmpty) {
          imagefiles.addAll(pickedfiles);
        } else {
          imagefiles = pickedfiles;
        }
      } else {
        log.i("No image is selected.");
      }
    } catch (e) {
      log.e('Error Occured: $e');
    }

    return imagefiles;
  }

  Future<XFile?> pickSingleImage({
    ImageSource? imageSource,
    int? imageQuality,
    double? maxHeight,
    double? maxWidth,
  }) async {
    var pickedFile = await imgpicker.pickImage(
      source: imageSource ?? ImageSource.gallery,
      imageQuality: imageQuality,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    XFile? imageFile;

    try {
      // *YOU CAN USE CAMERA FOR IMAGES AS WELL
      if (pickedFile != null) {
        imageFile = pickedFile;
      } else {
        log.i("No image is selected.");
      }
    } catch (e) {
      log.e('Error Occured: $e');
    }

    return imageFile;
  }
}
