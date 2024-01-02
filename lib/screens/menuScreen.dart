import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omniflow/cubits/taskcubit.dart';
import 'package:omniflow/screens/components/dragableContainer.dart';
import 'package:omniflow/screens/pdfEditor.dart';
import 'package:omniflow/screens/pdfWithSync.dart';
import 'package:omniflow/screens/videoDownload.dart';

class TaskMenu extends StatefulWidget {
  const TaskMenu({Key? key}) : super(key: key);

  @override
  State<TaskMenu> createState() => TaskMenuState();
}

class TaskMenuState extends State<TaskMenu> {
  PageRouteBuilder createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OptionWidget(
                  title: "Edit PDF",
                  imageAsset: "assets/images/pdf-file.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        createRoute(syncPdf(
                          title: "null",
                        )));
                  },
                ),
                SizedBox(height: 20),
                OptionWidget(
                  title: "Download YouTube Video",
                  imageAsset: "assets/images/youtube.png",
                  onTap: () {
                    Navigator.push(context, createRoute(VideoDownloader()));

                    // Add your logic for downloading YouTube video
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    Key? key,
    required this.title,
    required this.imageAsset,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        tileColor: Colors.purple.shade100,
        leading: Image.asset(
          imageAsset,
          width: 100,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
