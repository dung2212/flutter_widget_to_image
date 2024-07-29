import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DemoView extends StatelessWidget {
  const DemoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final query = MediaQuery.of(context);
    // return Container(
    //   color: Colors.blue,
    //   child: MediaQuery(
    //     data: query.copyWith(
    //       devicePixelRatio: 1,
    //       textScaleFactor: 1,
    //       boldText: false,
    //     ),
    //     child: _child(),
    //   ),
    // );
    return _child();
  }

  Widget _child() {
    return Text(
      " 1 It should be noted that the difference in speed is not overly significant when you consider that it can do the conversion any way 1 Million times in 0.1 seconds.",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 20,
        fontFamily: GoogleFonts.roboto(fontWeight: FontWeight.w400).fontFamily
      ),
    );
  }
}
