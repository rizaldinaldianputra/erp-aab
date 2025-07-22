import 'dart:io';

import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../attendance.dart';

class TakePhotoClockInPage extends StatefulWidget {
  const TakePhotoClockInPage({
    Key? key,
    required this.workingFrom,
  }) : super(key: key);

  final WorkingFromType workingFrom;

  @override
  State<TakePhotoClockInPage> createState() => _TakePhotoClockInPageState();
}

class _TakePhotoClockInPageState extends State<TakePhotoClockInPage> {
  late final UploadPhotoBloc _bloc;
  File? _currentFile;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<UploadPhotoBloc>()..add(CancelUploadPhotoEvent());
    _openCamera();
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (!mounted) return;

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() => _currentFile = imageFile);

      _bloc.add(GetUploadPhotoEvent(
        image: imageFile,
        date: DateTime.now(),
        type: AttendanceClockType.clockIn,
        workingFrom: widget.workingFrom,
      ));
    } else {
      Navigator.pop(context); // user batal ambil foto
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _bloc.add(CancelUploadPhotoEvent());
        return true;
      },
      child: BlocProvider.value(
        value: _bloc,
        child: Scaffold(
          body: BlocListener<UploadPhotoBloc, UploadPhotoState>(
            listener: (context, state) {
              if (!mounted) return;

              if (state is UploadPhotoLoading) {
                IndicatorsUtils.showLoadingSnackBar(context);
              } else {
                IndicatorsUtils.hideCurrentSnackBar();
              }

              if (state is UploadPhotoFailure) {
                IndicatorsUtils.showErrorSnackBar(
                    context, state.failure.message);
              } else if (state is UploadPhotoSuccess) {
                Navigator.pushReplacementNamed(
                  context,
                  '/attendance/clock-in/check-placement',
                  arguments: {
                    'imageId': state.data.id,
                    'working_from': state.data.workingFrom,
                  },
                );
              }
            },
            child: Center(
              child: _currentFile != null
                  ? Image.file(_currentFile!)
                  : const Text("Membuka kamera..."),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    IndicatorsUtils.hideCurrentSnackBar();
    super.dispose();
  }
}
