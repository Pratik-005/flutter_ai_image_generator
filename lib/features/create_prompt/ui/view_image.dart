import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_image_generator/features/create_prompt/bloc/create_prompt_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ViewImage extends StatelessWidget {
  final String? imageUrl;
  const ViewImage({super.key, this.imageUrl});

  static Future<bool> _getPermissionStatus() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt <= 28) {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
      return true;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  void saveImage(BuildContext context) async {
    try {
      bool granted = await _getPermissionStatus();

      if (!granted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Permission Required"),
            content: Text("Please enable storage permission from settings."),
            actions: [
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: Text("Open Settings"),
              ),
            ],
          ),
        );
        return;
      }

      final dio = Dio();

      final res = await dio.get(
        imageUrl!,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaverPlus.saveImage(
        res.data,
        quality: 100,
        name: 'image_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      if (result['isSuccess'] == true || result != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image saved to gallery")));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error saving image !")));
      throw Exception("Failed to save to image: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: Image.network(imageUrl!, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        context.read<CreatePromptBloc>().add(
                          PromptInitialEvent(),
                        );
                        Navigator.pop(context);
                      },
                      label: Text('Back'),
                      icon: Icon(Icons.arrow_back_rounded),
                    ),
                  ),

                  SizedBox(width: 20),

                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        saveImage(context);
                      },
                      label: Text('Save'),
                      icon: Icon(Icons.save),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
