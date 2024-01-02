// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:omniflow/screens/components/dragableContainer.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_manipulator/pdf_manipulator.dart';
// import 'package:open_file/open_file.dart';

// class PDFEditor extends StatefulWidget {
//   const PDFEditor({Key? key}) : super(key: key);

//   @override
//   State<PDFEditor> createState() => _PDFEditorState();
// }

// class _PDFEditorState extends State<PDFEditor> {
//   double fontSizeValue = 20;
//   double opacityValue = 1;
//   Color colorValue = Colors.black;
//   int pdfPageLength = 0;
//   double hue = 0.0;
//   List<double> xcord = [58];
//   List<double> ycord = [114];
//   TextEditingController watermarkController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: watermarkController,
//                 decoration: InputDecoration(
//                   labelText: 'Watermark',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(90),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 2),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Aa',
//                     style:
//                         TextStyle(fontSize: fontSizeValue, color: colorValue),
//                   ),
//                 ),
//               ),
//               Text('Select a Font Size:'),
//               CupertinoSlider(
//                 min: 20.0,
//                 max: 100.0,
//                 value: fontSizeValue,
//                 onChanged: (value) {
//                   setState(() {
//                     fontSizeValue = value;
//                   });
//                 },
//               ),
//               SizedBox(height: 20),
//               Text('Select Visibility of Watermark:'),
//               CupertinoSlider(
//                 min: 0.0,
//                 max: 1.0,
//                 value: opacityValue,
//                 onChanged: (value) {
//                   setState(() {
//                     opacityValue = value;
//                     colorValue = hue == 0
//                         ? Color.fromRGBO(0, 0, 0, opacityValue)
//                         : HSLColor.fromAHSL(value, hue, 1.0, 0.5).toColor();
//                   });
//                 },
//               ),
//               SizedBox(height: 20),
//               Text('Select a color:'),
//               CupertinoSlider(
//                 min: 0,
//                 max: 360,
//                 value: hue,
//                 onChanged: (double value) {
//                   setState(() {
//                     hue = value;
//                     if (hue == 0) {
//                       colorValue = Color.fromRGBO(0, 0, 0, opacityValue);
//                     } else {
//                       colorValue =
//                           HSLColor.fromAHSL(opacityValue, value, 1.0, 0.5)
//                               .toColor();
//                     }
//                   });
//                 },
//               ),
//               Text(('Choose custom location')),
//               Container(
//                 child: DraggableContainer(
//                   title: Text('${watermarkController.text}'),
//                   positionUpdate: (Offset position) {
//                     xcord.clear();
//                     ycord.clear();
//                     for (int i = 0; i < pdfPageLength; i++) {
//                       if (!xcord.contains(position.dx)) {
//                         xcord.add(position.dx);
//                       }
//                       if (!ycord.contains(position.dy)) {
//                         ycord.add(position.dy);
//                       }
//                     }
//                   },
//                 ),
//               ),
//               TextButton(
//                 onPressed: _filePicker,
//                 child: Text(
//                   'Add watermark',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.resolveWith(
//                       (states) => Colors.blue),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _filePicker() async {
//     try {
//       final pdfmanipulator = PdfManipulator();
//       FilePickerResult? result = await FilePicker.platform
//           .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

//       final totalPage = await pdfmanipulator.pdfPagesSize(
//           params: PDFPagesSizeParams(pdfPath: '${result!.files.single.path!}'));
//       print(totalPage);
//       pdfPageLength = totalPage!.length;
//       List<double> extendedListx = List.generate(
//         pdfPageLength,
//         (index) => xcord[index % xcord.length],
//       );
//       List<double> extendedListy = List.generate(
//         pdfPageLength,
//         (index) => ycord[index % ycord.length],
//       );
//       print(pdfPageLength);
//       print(extendedListx);
//       print(extendedListy);
//       final params = PDFWatermarkParams(
//         rotationAngle: 45,
//         customPositionXCoordinatesList: extendedListx,
//         customPositionYCoordinatesList: extendedListy,
//         pdfPath: result.files.single.path!,
//         text: watermarkController.text,
//         fontSize: fontSizeValue,
//         opacity: opacityValue,
//         watermarkColor: colorValue,
//         positionType: PositionType.custom,
//       );
//       xcord = [58];
//       ycord = [114];
//       print(params.customPositionXCoordinatesList!.length == pdfPageLength);
//       print(params.customPositionYCoordinatesList!.length == pdfPageLength);
//       String? resultPdf = await _pdfWatermark(params);
//       final file = File(resultPdf!);
//       DateTime today = DateTime.now();
//       final date = "${today.day}-${today.month}-${today.year}";
//       Uint8List bytes = await file.readAsBytes();
//       String? path = await getDownloadPath();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           "Watermark Added at $path ${watermarkController.text}-$date.pdf",
//         ),
//       ));
//       SaveFile.saveAndLaunchFile(
//         bytes,
//         "${watermarkController.text}-$date.pdf",
//         path!,
//         context,
//       );
//     } on PlatformException catch (e) {
//       log(e.toString());
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   Future<String?> _pdfWatermark(PDFWatermarkParams params) async {
//     String? result;
//     final _pdfManipulatorPlugin = PdfManipulator();
//     try {
//       result = await _pdfManipulatorPlugin.pdfWatermark(params: params);
//     } on PlatformException catch (e) {
//       log(e.toString());
//     } catch (e) {
//       log(e.toString());
//     }
//     return result;
//   }

//   Future<String?> getDownloadPath() async {
//     Directory? directory;
//     try {
//       if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       } else {
//         directory = Directory('/storage/emulated/0/Download');
//         if (!await directory.exists()) {
//           directory = await getExternalStorageDirectory();
//         }
//       }
//     } catch (err, stack) {
//       print("Cannot get download folder path");
//     }
//     return directory?.path;
//   }
// }

// class SaveFile {
//   static Future<void> saveAndLaunchFile(
//     Uint8List bytes,
//     String fileName,
//     String path,
//     BuildContext context,
//   ) async {
//     Directory directory = await getTemporaryDirectory();
//     String tempPath = directory.path;
//     File file = File('$tempPath/$fileName');
//     await file.writeAsBytes(bytes, flush: false);
//     OpenFile.open('$tempPath/$fileName');
//   }
// }
