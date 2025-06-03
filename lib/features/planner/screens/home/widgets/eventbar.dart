import 'package:flutter/material.dart';

class EventBar extends StatelessWidget {
  const EventBar({super.key, required this.height, required this.baseTop});

  final double height;
  final double baseTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: height,
      margin: EdgeInsets.only(left: 30, right: 30, top: baseTop),
      padding: const EdgeInsets.only(right: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black38,
              offset: const Offset(0.0, 10.0),
              blurRadius: 20.0)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.33,
              height: 60,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: Theme.of(context).primaryColor),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.directions, size: 30, color: Colors.white),
                  Text(
                    "Directions",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              )),
          Icon(
            Icons.share,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          Icon(
            Icons.call,
            color: Theme.of(context).primaryColor,
            size: 30,
          )
        ],
      ),
    );
  }
}
