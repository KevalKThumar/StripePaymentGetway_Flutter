// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ImageProviders with ChangeNotifier {
  XFile? _image;
  XFile? get image => _image;
  set setImage(XFile? image) {
    _image = image;
    notifyListeners();
  }

// use image picker to pick an image
  Future<void> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final ImageCropper imageCropper = ImageCropper();
    final XFile? images = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    final croppedImage = await imageCropper.cropImage(
      sourcePath: images!.path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 70,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioLockEnabled: true,
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioPickerButtonHidden: true,
          resetButtonHidden: true,
          doneButtonTitle: 'Done',
        ),
      ],
    );

    if (croppedImage == null) return;
    setImage = XFile(croppedImage.path);
  }

  Future<void> shareImage(BuildContext context, String imagePath) async {
    final box = context.findRenderObject() as RenderBox;

    ShareResult shareResult;

    if (imagePath.isNotEmpty) {
      shareResult = await Share.shareXFiles(
        [XFile(imagePath)],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        subject: "Shared image from gallery",
        text: imagePath,
      );
      if (shareResult.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image shared successfully"),
          ),
        );
      }
    }
  }

  void onShareXFileFromNetwork(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Replace the URL with the URL of your network image
    const imageUrl =
        'https://images.pexels.com/photos/719396/pexels-photo-719396.jpeg';

    // Download the image from the network
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Convert response body to Uint8List
      final Uint8List imageData = response.bodyBytes;

      // Create XFile from downloaded image data
      final shareResult = await Share.shareXFiles(
        [
          XFile.fromData(
            imageData,
            name: 'image.jpeg',
            mimeType: 'image/jpeg',
          ),
        ],
        subject: "Shared image from network",
        text: imageUrl,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      if (shareResult.status == ShareResultStatus.success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Shared image from network'),
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Failed to share image from network'),
          ),
        );
      }
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to download image from network'),
        ),
      );
    }
  }

  void clear() {
    _image = null;
    notifyListeners();
  }
}
