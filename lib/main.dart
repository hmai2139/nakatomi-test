import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var actualText = "Roses";

  TextPainter buildPainter(int maxLines, TextStyle textStyle) {
    return TextPainter(
        text: TextSpan(
          text: actualText,
          style: textStyle.copyWith(overflow: TextOverflow.visible),
        ),
        maxLines: maxLines,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 30,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
    );

    // Start at maxLines = 1.
    int maxLines = 1;

    // Min height and width.
    double height = 72;
    double width = 72;

    /* Height and width adjustments, e.g from padding/margin/author text.
    These values are obtained by wrapping Text widget w/ `actualText` w/
    LayoutBuilder.
    */
    double heightAdjustment = 33;
    double widthAdjustment = 16;

    /* Create a TextPainter object to draw `actualText`
    at maxLines = 1 to get the actual line height.
    */
    var painter = buildPainter(maxLines, textStyle);
    painter.layout(maxWidth: width - widthAdjustment);

    // Calculate `maxLines` = available width divided by line height.
    final maxHeight = 88 - heightAdjustment;
    maxLines = (maxHeight/painter.preferredLineHeight).floor();

    // Rebuild painter with calculated `maxLines`.
    painter = buildPainter(maxLines, textStyle);
    painter.layout(maxWidth: width - widthAdjustment);

    /* If text overflows: iterate and increase width until
     the required size is found, or constraints are reached.
    */
    final maxWidth = 196 - widthAdjustment;
    while (painter.didExceedMaxLines && (painter.width < maxWidth)) {
      painter.layout(maxWidth: painter.width + 1);
    }

    // Calculate the minimum required size.
    width = max(min(painter.width + widthAdjustment, 196), width);
    height = max(min(painter.height + heightAdjustment, 88), height);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 88.0 - height,
                left: 4.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                  maxWidth: width >= 70 ? width + 2 : 72, // For border
),
              height: height,
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: Text(
                            "AUTHOR",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(fontSize: 9, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    actualText,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  )
                ],
              ),
            ),
            // Text field for testing purpose.
            // TextFormField(
            //     initialValue: actualText,
            //     onChanged: (text) => {
            //           setState(() {
            //             actualText = text;
            //           })
            //         })
          ],
        ),
      ),
    );
  }
}
