import 'package:flutter/material.dart';

class EventBanner extends StatelessWidget {
  const EventBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return (Container(
        height: 160,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.75,
            left: 40,
            right: 40),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        margin: const EdgeInsets.only(left: 14, top: 14),
                        child: const Text(
                          "Shoreline Amphiyheatre in Mountain View, CA.",
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        margin: const EdgeInsets.only(left: 14, top: 6),
                        child: const Text(
                          "USA",
                          style: TextStyle(color: Colors.black38, fontSize: 12),
                        ))
                  ],
                ),
                Container(
                  height: 80,
                  width: 80,
                  margin: const EdgeInsets.only(right: 14, top: 14),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: AssetImage("assets/images/googleio.jpg"),
                          fit: BoxFit.cover)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 140,
                  height: 30,
                  margin: const EdgeInsets.only(left: 14, top: 6),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(Icons.directions,
                          color: Theme.of(context).primaryColor, size: 24),
                      Text(
                        "Directions",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        )));
  }
}
