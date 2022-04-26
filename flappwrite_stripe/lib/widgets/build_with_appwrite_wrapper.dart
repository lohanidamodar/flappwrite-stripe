import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BuiltWithAppwriteWrapper extends StatelessWidget {
  const BuiltWithAppwriteWrapper({Key? key, required this.child})
      : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    try {
                      launchUrl(Uri.parse('https://appwrite.io'));
                    } catch (e) {}
                  },
                  child: SvgPicture.asset('assets/built-with-appwrite-hr.svg')),
            ),
          ),
        ],
      ),
    );
  }
}
