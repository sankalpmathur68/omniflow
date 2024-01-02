import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omniflow/screens/components/dragableContainer.dart';
import 'package:omniflow/screens/videoDownload.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class syncPdf extends StatefulWidget {
  final title;
  const syncPdf({required this.title});

  @override
  State<syncPdf> createState() => _syncPdfState();
}

class _syncPdfState extends State<syncPdf> {
  double fontSizeValue = 20;
  double opacityValue = 1;
  Color colorValue = Colors.black;
  int pdfPageLength = 0;
  double hue = 0.0;
  double x = 0;
  double r = 0;
  double g = 0;
  double b = 0;
  double y = 0;
  List<double> xcord = [58];
  List<double> ycord = [114];
  TextEditingController watermarkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title.
        title: Text("PDF Watermark"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: watermarkController,
                  decoration: InputDecoration(
                    labelText: 'Watermark',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Select Custom Position',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: DraggableContainer(
                    title: watermarkController.text == ''
                        ? Text(
                            "Watermark",
                            style: TextStyle(
                                color: Color.fromRGBO(r.toInt(), g.toInt(),
                                    b.toInt(), opacityValue),
                                fontSize: fontSizeValue * (210 / 297)),
                          )
                        : Text(
                            '${watermarkController.text}',
                            // softWrap: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(r.toInt(), g.toInt(),
                                    b.toInt(), opacityValue),
                                fontSize: fontSizeValue * (210 / 297)),
                          ),
                    positionUpdate: (pos) {
                      xcord.clear();
                      ycord.clear();
                      x = pos.dx;
                      y = pos.dy;
                      // xcord.add(position.dx);
                      // ycord.add(position.dy);
                      // for (int i = 0; i < pdfPageLength; i++) {
                      //   if (!xcord.contains(position.dx)) {
                      //   }
                      //   if (!ycord.contains(position.dy)) {
                      //   }
                      // }
                    },
                  ),
                ),
                Text('Select a Font Size:'),
                CupertinoSlider(
                  min: 20.0,
                  max: 100.0,
                  value: fontSizeValue,
                  onChanged: (value) {
                    setState(() {
                      fontSizeValue = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Select Visibility of Watermark:'),
                CupertinoSlider(
                  min: 0.0,
                  max: 1.0,
                  value: opacityValue,
                  onChanged: (value) {
                    setState(() {
                      opacityValue = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Choose color:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("R"),
                    CupertinoSlider(
                      activeColor: Colors.red,
                      min: 0,
                      max: 255,
                      value: r,
                      onChanged: (double value) {
                        setState(() {
                          r = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("B"),
                    CupertinoSlider(
                      activeColor: Colors.blue,
                      min: 0,
                      max: 255,
                      value: b,
                      onChanged: (double value) {
                        setState(() {
                          b = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("G"),
                    CupertinoSlider(
                      activeColor: Colors.green,
                      min: 0,
                      max: 255,
                      value: g,
                      onChanged: (double value) {
                        setState(() {
                          g = value;
                        });
                      },
                    ),
                  ],
                ),
                TextButton(
                  child: Text(
                    'Add watermark',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.blue)),
                  onPressed: () {
                    _addWatermarkToPDF(width, height);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addWatermarkToPDF(w, h) async {
    DateTime today = DateTime.now();
    final date = "${today.day}-${today.month}-${today.year}";
//Load the PDF document
    PdfDocument document = PdfDocument(inputBytes: await _readDocumentData());

//Get first page from document
    for (int pageIndex = 0; pageIndex < document.pages.count; pageIndex++) {
      PdfPage page = document.pages[pageIndex];
//Get page size
      Size pageSize = page.getClientSize();
//Set a standard font
      PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, fontSizeValue);
//Measure the text
      Size size = font.measureString('Confidential');
//Create PDF graphics for the page
      PdfGraphics graphics = page.graphics;
      // PdfColor clr = PdfColor(red, green, blue)
//Calculate the center point
      // double x = pageSize.width / 2;
      // double y = pageSize.height / 2;
      // print((pageSize.width));
      // print((pageSize.height));
      // print(x);
      // print(y);
      // print((pageSize.width / w));
      // print((pageSize.height / h));
//Save the graphics state for the watermark text
      graphics.save();

//Tranlate the transform with the center point
      graphics.translateTransform((x * (pageSize.width / 210)) + 50,
          (y * (pageSize.height / 297)) + 50);
//Set transparency level for the text
      graphics.setTransparency(opacityValue);
//Rotate the text to -40 Degree
      graphics.rotateTransform(-40);
//Draw the watermark text to the desired position over the PDF page with red color
      graphics.drawString('${watermarkController.text}', font,
          pen: PdfPen(PdfColor(r.toInt(), g.toInt(), b.toInt())),
          brush: CustomPdfBrush(PdfColor(r.toInt(), g.toInt(), b.toInt()),
              colors:
                  Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), opacityValue))

          // bounds: Rect.fromLTWH(
          //     -size.width / 2, -size.height / 2, size.width, size.height)
          );
    }
//Restore the graphics
    // graphics.restore();
//Save the document
    List<int> bytes = await document.save();
//Dispose the document
    document.dispose();
//Save the file and launch/download
    SaveFile.saveAndLaunchFile(bytes, '${watermarkController.text}-$date.pdf');
  }

  Future<List<int>> _readDocumentData() async {
    String? path = await filepicker();
    File file = File(path!);
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  filepicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      return result!.files.single.path!;
    } catch (e) {
      print(e);
    }
  }
}

class SaveFile {
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
//Get external storage directory
    String? path = await getDownloadPath();
    Directory dir = await getTemporaryDirectory();
//Get directory path
    String path2 = dir.path;
//Create an empty file to write PDF data
    File file = File('$path/$fileName');
    File file2 = File('$path2/$fileName');
//Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    await file2.writeAsBytes(bytes, flush: true);
//Open the PDF document in mobile
    OpenFile.open('$path2/$fileName');
  }
}

// class colorWidget extends PdfColor{
//   colorWidget({});
// }

class CustomPdfBrush extends PdfSolidBrush {
  // Add any additional properties or methods specific to your custom brush
  // final color;
  // Constructor for your custom brush
  CustomPdfBrush(super.color, {required this.colors});
  final colors;
  // Implement or override any methods as needed

  // Add any additional methods specific to your custom brush
}
