import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:photo_view/photo_view.dart';
import '../functions.dart';

List<String> IMAGE_EXTENSIONS = ['jpg', 'png', 'jpeg'];
List<String> DOCUMENT_EXTENSIONS = ['pdf', 'doc', 'docx'];

class SimpleImagePicker extends StatefulWidget {
  const SimpleImagePicker({
    Key? key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
  }) : super(key: key);

  final dynamic item;
  final Function onChange;
  final int position;
  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;

  @override
  _SimpleImagePickerState createState() => _SimpleImagePickerState();
}

class _SimpleImagePickerState extends State<SimpleImagePicker> {
  final List<dynamic> _imageFiles = [];

  dynamic item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  Future<void> _pickImages() async {
    List<dynamic> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: IMAGE_EXTENSIONS + DOCUMENT_EXTENSIONS,
    );

    if (result != null && result.files.isNotEmpty) {
      // if (!kIsWeb) {
      //   // For non-web platforms, directly map file paths to File objects
      //   files = result.paths.map((path) => File(path!)).toList();
      //   // _image_bytes =
      //   //     result.paths.map((path) => File(path!).readAsBytesSync()).toList();
      // } else if (kIsWeb) {
      //   // For web platform, map bytes to memory files
      //   files = result.files.map((file) => file.bytes!).toList();
      // }
      files = result.files
          .map((file) => {'image': file.bytes, 'ext': file.extension})
          .toList();

      setState(() {
        _imageFiles.addAll(files);
        _saveImagesToForm();
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      _saveImagesToForm();
    });
  }

  void _saveImagesToForm() {
    //TODO this is honestly a terrible idea, I dont know what I was thinking. - Dylan
    // Its really slow, we need to do some sort of async upload to the server instead.
    // API call to upload or remove images to the server. Obviously this would require a web connection.
    // Will need to block users from submitting attachments without web connection.
    // How will we load images back to the app?
    // We should also allow the user to click the image to view the full size.
    // if (!kIsWeb) {
    //   // Compress the image bytes and save to item['value']
    //   List<int> data = utf8.encode(jsonEncode({'images': _imageFiles.map((file) => File(file!).readAsBytesSync()).toList()}));
    //   List<int> compressedData =  ZLibEncoder().encode(data);
    //   item['value'] = base64.encode(compressedData);
    // } else if (kIsWeb) {
    //   // Convert the list of image bytes to JSON and gzip it
    //   List<int> data = utf8.encode(jsonEncode({'images': _imageFiles}));
    //   List<int> compressedData = ZLibEncoder().encode(data);
    //   item['value'] = base64.encode(compressedData);
    // }

    // item['value'] = jsonEncode({'images': _imageFiles});
  }

  @override
  Widget build(BuildContext context) {
    Widget label = const SizedBox.shrink();
    if (Fun.labelHidden(item)) {
      label = Text(
        item['label'],
        style: Theme.of(context).textTheme.headlineSmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        label,
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('Pick Files'),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _imageFiles
              .asMap()
              .entries
              .map(
                (entry) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FullScreenImageDialog(image: entry.value);
                      },
                    );
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: getThumbnailOfFile(entry.value)),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          onPressed: () => _deleteImage(entry.key),
                          icon: const Icon(Icons.delete_forever_rounded),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  getThumbnailOfFile(file) {
    if (IMAGE_EXTENSIONS.contains(file['ext'])) {
      // handle if file is an image
      if (file['image'] is Uint8List) {
        //file is bytes
        return Image.memory(file['image'], fit: BoxFit.cover);
      } else if (file['image'] is File) {
        //file is a file
        return Image.file(file['image'], fit: BoxFit.cover);
      }
    } else if (DOCUMENT_EXTENSIONS.contains(file['ext'])) {
      // handle if the file is a document
      if (file['ext'] == 'pdf') {
        //PDF rendering for bytes and file
        if (file['image'] is Uint8List) {
          return PdfDocumentLoader.openData(file['image'],
              pageNumber: 1,
              pageBuilder: (context, textureBuilder, pageSize) =>
                  textureBuilder());
        } else if (file['image'] is File) {
          return PdfDocumentLoader.openFile(file['image'],
              pageNumber: 1,
              pageBuilder: (context, textureBuilder, pageSize) =>
                  textureBuilder());
        }
      }
      // It must be some other type of file
      return FittedBox(
          fit: BoxFit.cover, child: Icon(Icons.file_present_rounded));
    }
  }
}

class FullScreenImageDialog extends StatelessWidget {
  final dynamic image;

  const FullScreenImageDialog({Key? key, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    // If the file is in bytes
    if (image["image"] is Uint8List &&
        IMAGE_EXTENSIONS.contains(image['ext'])) {
      // If the image is in bytes
      return PhotoView(
        imageProvider: MemoryImage(image["image"]),
        tightMode: true,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.0,
      );
    } else if (image["image"] is File &&
        IMAGE_EXTENSIONS.contains(image['ext'])) {
      // If the image is a file
      return PhotoView(
        imageProvider: FileImage(image),
        tightMode: true,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.0,
      );
    } else if (image['ext'] == 'pdf') {
      if (image['image'] is Uint8List) {
        return PdfDocumentLoader.openData(image['image'],
            pageNumber: 1,
            pageBuilder: (context, textureBuilder, pageSize) =>
                textureBuilder());
      } else if (image['image'] is File) {
        return PdfDocumentLoader.openFile(image['image'],
            pageNumber: 1,
            pageBuilder: (context, textureBuilder, pageSize) =>
                textureBuilder());
      }
    }
    // Handle other cases, such as network images
    return FittedBox(
        fit: BoxFit.cover, child: Icon(Icons.file_present_rounded));
  }
}
