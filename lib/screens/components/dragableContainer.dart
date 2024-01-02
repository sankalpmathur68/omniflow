import 'dart:math';

import 'package:flutter/material.dart';

class DraggableContainer extends StatefulWidget {
  final Function positionUpdate;
  Widget title;
  DraggableContainer({
    required this.title,
    required this.positionUpdate,
  });

  @override
  _DraggableContainerState createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  final double a4ContainerWidth = 210.0;
  final double a4ContainerHeight = 297.0;
  Offset position = Offset(50.0, 50.0);
  double deltaX = 0;
  double deltaY = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: a4ContainerWidth,
            height: a4ContainerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: Draggable(
                    child: Transform.rotate(
                      angle: -45 * (3.14 / 180),
                      child: Container(
                        // width: 100.0,
                        // height: 200,
                        color: Colors.transparent,
                        child: Center(
                          child: widget.title,
                          // child: Text(
                          //   '${widget.title}',
                          //   style: TextStyle(color: Colors.black),
                          //   textAlign: TextAlign.center,
                          // ),
                        ),
                      ),
                    ),
                    feedback: Transform.rotate(
                      angle: -45 * (3.14 / 180),
                      child: Container(
                        // width: 100.0,
                        // height: 50.0,
                        // decoration: ShapeDecoration(
                        //     color: Colors.black.withOpacity(.2),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(90))),
                        // color: Colors.black.withOpacity(0.2),
                        child: Center(

                            // child: Text(
                            //   '${widget.title}',
                            //   style: TextStyle(color: Colors.black),
                            //   textAlign: TextAlign.center,
                            // ),
                            ),
                      ),
                    ),
                    childWhenDragging: Transform.rotate(
                      angle: -45 * (3.14 / 180),
                      child: Container(
                        width: 100.0,
                        height: 50.0,
                        color: Colors.transparent,
                        child: Opacity(
                          opacity: 0.5,
                          child: Center(
                              // child: widget.title,
                              // child: Text(
                              //   '${widget.title}',
                              //   style: TextStyle(color: Colors.black),
                              //   textAlign: TextAlign.center,
                              // ),
                              ),
                        ),
                      ),
                    ),
                    onDraggableCanceled: (velocity, offset) {
                      // final distance = offset.distance;
                      // final direction = offset.direction;
                      // // print(direction);
                      // double x1 = 0;
                      // double y1 = 0;
                      // // Calculate the coordinates of the second point
                      // double x2 = x1 + distance * cos(direction);
                      // double y2 = y1 + distance * sin(direction);
                      // print("${x2}-${y2}");
                      // print(offset);
                      Offset offset1 = Offset(0, 0);
                      Offset offset2 = offset;
                      // Offset offset2 = offset;

                      // Calculate direction angle in radians
                      double direction = atan2(
                          offset2.dy - offset1.dy, offset2.dx - offset1.dx);

                      // Calculate distance
                      double distance = sqrt(pow(offset2.dx - offset1.dx, 2) +
                          pow(offset2.dy - offset1.dy, 2));
                      print('Direction: ${direction * 180 / pi} degrees');
                      print('Distance: $distance units');
                      print(offset);
                      setState(() {
                        position = offset;
                        handleDraggableCanceled();
                      });
                      widget.positionUpdate(Offset(deltaX, deltaY));
                    },
                    onDragUpdate: (details) {
                      setState(() {
                        handleDragUpdate(details);
                      });
                    },
                    maxSimultaneousDrags: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            '* Figure Shown Above Does not Replicate the Actual Size of PDF page. Font Size will not cover page as shown in Figure.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 5),
          Text(
            '** Position may vary sometime due to variance in  PDF page dimensions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                resetPosition();
              });
            },
            child: Icon(
              Icons.refresh,
              size: 50,
            ),
          )
        ],
      ),
    );
  }

  void handleDraggableCanceled() {
    // if (deltaX < 0 || deltaY < 20 || deltaX > 160 || deltaY > 245) {
    //   if (deltaX < 0 && deltaY < 20) {
    //     position = Offset(0, 20);
    //   } else if (deltaX < 0) {
    //     position = Offset(0, deltaY);
    //   } else if (deltaY < 20) {
    //     position = Offset(deltaX, 20);
    //   }
    //   if (deltaX > 150 && deltaY > 240) {
    //     position = Offset(150, 240);
    //   } else if (deltaX > 150) {
    //     position = Offset(150, deltaY);
    //   } else if (deltaY > 240) {
    //     position = Offset(deltaX, 240);
    //   }
    // } else {
    position = Offset(deltaX, deltaY);
    // }
// position =
    // if (deltaX > 150 || deltaY > 245) {
    //   if (deltaX > 160 && deltaY > 245) {
    //     position = Offset(160, 245);
    //   } else if (deltaX > 160) {
    //     position = Offset(160, deltaY);
    //   } else if (deltaY > 245) {
    //     position = Offset(deltaX, 245);
    //   }
    // } else {
    //   position = Offset(deltaX, deltaY);
    // }
  }

  void handleDragUpdate(DragUpdateDetails details) {
    deltaX += details.delta.dx;
    deltaY += details.delta.dy;
  }

  void resetPosition() {
    position = Offset(50, 50);
    deltaX = 0;
    deltaY = 0;
  }
}
