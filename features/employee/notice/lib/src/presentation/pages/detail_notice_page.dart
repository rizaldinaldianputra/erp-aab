import 'dart:async';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import 'package:component/component.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:files/files.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../notice.dart';

class DetailNoticePage extends StatefulWidget {
  final NoticeEntity notice;
  const DetailNoticePage({
    Key? key,
    required this.notice,
  }) : super(key: key);

  @override
  State<DetailNoticePage> createState() => _DetailNoticePageState();
}

class _DetailNoticePageState extends State<DetailNoticePage> {
  String? _pdfFilePath;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Future<Either<Failure, String>> _startDownloadingFile(String url) async {
    final path = await getTemporaryDirectory();
    return GetIt.I<DownloadFileUseCase>().call(
      DownloadFileParams(
        url,
        fileName: '${widget.notice.hashCode}.pdf',
        savePath:
            '${path.path}${Platform.pathSeparator}${widget.notice.hashCode}.pdf',
        withHttpClint: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    final result = await _startDownloadingFile(widget.notice.file!);
    if (result.isRight()) {
      final filePath = result.getOrElse(() => '');
      setState(() {
        _pdfFilePath = filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notice.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.notice.description != null &&
        widget.notice.description!.isNotEmpty) {
      return _buildHtmlView();
    }

    return _buildPDFView();
  }

  Widget _buildPDFView() {
    if (_pdfFilePath == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SfPdfViewer.file(
      File(_pdfFilePath!),
      key: _pdfViewerKey,
    );
  }

  Widget _buildHtmlView() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Html(
          data: widget.notice.description ?? '',
        ),
      ),
    );
  }
}
