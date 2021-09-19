// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swing_trimmer/presentation/aspect_ratio_video.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Demo',
      home: MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  dynamic _pickImageError;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> saveLocalImagePath(String? path) async {
    if (path == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('image', path);
  }

  Future<void> saveLocalImage(XFile? xFile) async {
    if (xFile == null) {
      return;
    }

    final path = await localPath();
    final fileName = basename(xFile.path);
    final imagePath = '$path/$fileName';
    log('imagePath: $imagePath');

    saveLocalImagePath(imagePath);

    // fileに保存
    xFile.saveTo(imagePath);
  }

  Future<void> saveLocalMovie(XFile? xFile) async {
    if (xFile == null) {
      return;
    }

    final path = await localPath();
    final fileName = basename(xFile.path);
    final moviePath = '$path/$fileName';
    log('moviePath: $moviePath');

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('movie', moviePath);

    // fileに保存
    xFile.saveTo(moviePath);
  }

  Future<String> localPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  Future<void> fetchLocalImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('image');
    if (path != null) {
      _imageFileList = [XFile(path)];
    }
  }

  Future<String?> fetchLocalMoviePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('movie');
  }

  void _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    final file = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    await saveLocalMovie(file);

    // 動画のサムネイルを取得し、画像を保存する
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: file!.path,
      thumbnailPath: await localPath(),
    );
    log('return thumbnail: $thumbnail');
    await saveLocalImagePath(thumbnail);
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewImages(BuildContext context) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
          child: GridView.count(
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            key: UniqueKey(),
            crossAxisCount: 3,
            children: _imageFileList!.map((e) {
              log('image path: ${e.path}');
              return GestureDetector(
                onTap: () async {
                  final moviePath = (await fetchLocalMoviePath()) ?? '';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AspectRatioVideo(
                        VideoPlayerController.file(File(moviePath)),
                      ),
                    ),
                  );
                },
                onLongPress: () async {
                  log('save gallery');
                  final result = await ImageGallerySaver.saveFile(
                      await fetchLocalMoviePath() ?? '');
                  log('complete save: result=$result');
                },
                child: Image.file(
                  File(e.path),
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
          label: 'image_picker_example_picked_images');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _imageFile = response.file;
      _imageFileList = response.files;
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLocalImagePath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _previewImages(context);
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : FutureBuilder<void>(
                future: fetchLocalImagePath(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _previewImages(context);
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery);
              },
              heroTag: 'video0',
              tooltip: 'Pick Video from gallery',
              child: const Icon(Icons.video_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera);
              },
              heroTag: 'video1',
              tooltip: 'Take a Video',
              child: const Icon(Icons.videocam),
            ),
          ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
