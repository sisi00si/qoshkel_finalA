import 'package:QoshKel/features/planner/screens/home/event.dart';
import 'package:flutter/material.dart';

class PictureButton extends StatelessWidget {
  const PictureButton(
      {super.key,
      required this.pic,
      required this.children,
      this.height = 100,
      this.width = 100,
      this.isEvent = false});
  final AssetImage pic;
  final double height;
  final double width;
  final bool isEvent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            width: width,
            margin: isEvent
                ? const EdgeInsets.symmetric(horizontal: 0)
                : const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: isEvent
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))
                    : BorderRadius.circular(20),
                image: DecorationImage(image: pic, fit: BoxFit.cover)),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Event()));
                },
                child: Container(
                  width: width,
                  height: height,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                        colors: [Colors.transparent, Color(0xff111111)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children),
                ))));
  }
}
