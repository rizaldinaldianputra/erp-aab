import 'dart:io';

import 'package:dependencies/dependencies.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationUtils {
  static Future<Position?> getCurrentLocation({
    required BuildContext context,
  }) async {
    try {
      // Cek apakah layanan lokasi aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

      // Cek dan minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return null;
      }

      // Ambil posisi sekarang
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Gagal mendapatkan lokasi: $e');
      return null;
    }
  }
}

extension FilesExtensions on List<File> {
  FormData toFormData() {
    return FormData.fromMap({
      'files[]': map(
        (file) => MultipartFile.fromFileSync(
          file.path,
          filename: file.path.split('/').last,
        ),
      ).toList(),
    });
  }
}
