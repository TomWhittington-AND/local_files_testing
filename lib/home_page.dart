import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

import 'models/about_you.dart';

class _MyHomePageState extends State<MyHomePage> {
  String contents = '';
  TextEditingController fileNameController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  File? selectedFile;
  String get selectedFileName {
    return selectedFile == null ? '' : basename(selectedFile!.path);
  }

  Future<Directory> get directory async {
    return await getApplicationSupportDirectory();
  }

  Future<void> getFiles() async {
    String value = '';
    var streams = (await directory).list();
    List<FileSystemEntity> fileSystemEntities = <FileSystemEntity>[];
    await streams.forEach((element) {
      fileSystemEntities.add(element);
    });

    for (FileSystemEntity element in fileSystemEntities) {
      value += '${basename(element.path)}\n\n';
    }

    setState(() {
      contents = value;
    });
  }

  Future<void> clearSelectedFile() async {
    fileNameController.text = '';
    contentsController.text = '';

    setState(() {
      selectedFile = null;
      contents = '';
    });
  }

  Future<void> selectFiles() async {
    if (fileNameController.text != '') {
      File file = File('${(await directory).path}/${fileNameController.text}');
      setState(() => selectedFile = file);
    }
  }

  Future<void> createFile() async {
    File newFile = await selectedFile!.create();
    setState(() => selectedFile = newFile);
    await getFiles();
  }

  Future<void> deleteFile() async {
    await selectedFile!.delete();
    await clearSelectedFile();
    await getFiles();
  }

  Future<void> writeFile() async {
    selectedFile!.writeAsString(contentsController.text);
    readFile();
  }

  Future<String> readFile() async {
    String value = await selectedFile!.readAsString();
    setState(() => contents = value);
    return value;
  }

  Future<void> writeModel() async {
    AboutYou aboutYou = AboutYou('www.google.com', 'Tom Whittington',
        'Product Developer', DateTime(2022, 11, 7));
    String json = jsonEncode(aboutYou);
    contentsController.text = json;
    await writeFile();
  }

  Future<void> readModel() async {
    AboutYou model = AboutYou.fromJson(jsonDecode(await readFile()));

    setState(() {
      contents = model.toString();
    });
  }

  ElevatedButton getDisabledButton(
      Function()? onPressed, bool whenToEnable, String text) {
    return ElevatedButton(
      onPressed: whenToEnable ? onPressed : null,
      child: Text(
        text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: getFiles,
              child: const Text(
                "Get Files",
              ),
            ),
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(labelText: 'File Name'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getDisabledButton(clearSelectedFile, selectedFile != null,
                    'Clear Selected File'),
                getDisabledButton(
                    selectFiles, selectedFile == null, ' Select File'),
              ],
            ),
            Text('Selected file: $selectedFileName'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getDisabledButton(
                    createFile, selectedFile != null, 'Create File'),
                getDisabledButton(
                    deleteFile, selectedFile != null, 'Delete File'),
              ],
            ),
            TextField(
              controller: contentsController,
              decoration: const InputDecoration(labelText: 'File contents'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getDisabledButton(
                    writeModel, selectedFile != null, 'Write Model'),
                getDisabledButton(
                    readModel, selectedFile != null, 'Read Model'),
                getDisabledButton(writeFile, selectedFile != null, 'Write'),
                getDisabledButton(readFile, selectedFile != null, 'Read'),
              ],
            ),
            Text(contents)
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
