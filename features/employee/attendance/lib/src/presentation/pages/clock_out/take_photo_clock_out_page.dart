import 'dart:io';

import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../attendance.dart';

class TakePhotoClockOutPage extends StatefulWidget {
  const TakePhotoClockOutPage({
    Key? key,
    required this.workingFrom,
  }) : super(key: key);

  final WorkingFromType workingFrom;

  @override
  _TakePhotoClockOutPageState createState() => _TakePhotoClockOutPageState();
}

class _TakePhotoClockOutPageState extends State<TakePhotoClockOutPage> {
  late final UploadPhotoBloc _bloc;
  File? _currentFile;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<UploadPhotoBloc>();
    _bloc.add(CancelUploadPhotoEvent());
    _openCamera();
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      setState(() {
        _currentFile = imageFile;
      });

      _bloc.add(GetUploadPhotoEvent(
        image: imageFile,
        date: DateTime.now(),
        type: AttendanceClockType.clockOut,
        workingFrom: widget.workingFrom,
      ));
    } else {
      if (mounted) Navigator.pop(context);
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
              if (state is UploadPhotoSuccess) {
                if (mounted) IndicatorsUtils.hideCurrentSnackBar();
                Navigator.pushReplacementNamed(
                  context,
                  '/attendance/clock-out/check-placement',
                  arguments: {
                    'imageId': state.data.id,
                    'working_from': state.data.workingFrom,
                  },
                );
              } else if (state is UploadPhotoLoading) {
                IndicatorsUtils.showLoadingSnackBar(context);
              } else if (state is UploadPhotoFailure) {
                IndicatorsUtils.showErrorSnackBar(
                    context, state.failure.message);
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
    if (mounted) IndicatorsUtils.hideCurrentSnackBar();
    super.dispose();
  }
}
