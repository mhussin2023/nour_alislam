import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'data_Files/book_files_links.dart';

class PngViewerPage extends StatefulWidget {
  final int bookNumber;
  final int pageNumber;

  const PngViewerPage({
    super.key,
    required this.bookNumber,
    required this.pageNumber,
  });

  @override
  State<PngViewerPage> createState() => _PngViewerPageState();
}

class _PngViewerPageState extends State<PngViewerPage> {
  File? _imageFile;
  bool _isLoading = true;
  String? _error;
  late String _fileName;
  late String _googleDriveLink;

  @override
  void initState() {
    super.initState();
    _fileName = 'book_${widget.bookNumber}_page_${widget.pageNumber}.png';
    //_googleDriveLink =
    //    'https://drive.google.com/file/d/BOOK${widget.bookNumber}_PAGE${widget.pageNumber}/view';
    var found=Book_files_links.firstWhere((element) {
      return int.parse(element[0].toString())==widget.pageNumber &&
          int.parse(element[3].toString())==widget.bookNumber;
    });
    _googleDriveLink=found[2].toString();


    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final localFile = File('${dir.path}/$_fileName');

      if (await localFile.exists()) {
        setState(() {
          _imageFile = localFile;
          _isLoading = false;
        });
        return;
      }

      final fileId = _extractFileId(_googleDriveLink);
      var downloadUrl = 'https://drive.google.com/uc?export=download&id=$fileId';

      var response = await http.get(Uri.parse(downloadUrl));

      if (response.headers['content-type']?.contains('text/html') == true) {
        final confirmMatch =
            RegExp(r'confirm=([^&]+)').firstMatch(response.body);
        if (confirmMatch != null) {
          downloadUrl += '&confirm=${confirmMatch.group(1)}';
          response = await http.get(Uri.parse(downloadUrl));
        }
      }

      if (response.statusCode != 200) {
        throw HttpException('Download failed (${response.statusCode})');
      }

      await localFile.writeAsBytes(response.bodyBytes);

      setState(() {
        _imageFile = localFile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _extractFileId(String link) {
    final match = RegExp(r'/d/([a-zA-Z0-9_-]+)').firstMatch(link);
    if (match != null) return match.group(1)!;
    if (!link.contains('drive.google.com')) return link;
    throw FormatException('Could not extract file ID from: $link');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_fileName)),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _error != null
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $_error', textAlign: TextAlign.center),
                  )
                : InteractiveViewer(
                    child: Image.file(_imageFile!, fit: BoxFit.contain),
                  ),
      ),
    );
  }
}
