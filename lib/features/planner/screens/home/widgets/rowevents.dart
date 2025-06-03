import 'package:flutter/material.dart';
import 'package:QoshKel/features/planner/screens/home/widgets/picturebutton.dart';

class RowEvents extends StatelessWidget {
  const RowEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text(
                      "Events",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 16, left: 15),
                    child: Hero(
                        tag: "event1",
                        child: PictureButton(
                          height: 180,
                          width: MediaQuery.of(context).size.width - 40,
                          pic: const AssetImage("assets/images/googleio.jpg"),
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: const Text(
                                  "Google IO - 2019",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: const Text(
                                  "Technology Presentation",
                                  style: TextStyle(
                                      color: Color(0xaaffffff), fontSize: 12),
                                )),
                            Container(
                                width: 70,
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xDD333333)),
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Fri / 20:00",
                                        style: TextStyle(
                                            color: Color(0xaaffffff),
                                            fontSize: 10),
                                      ),
                                    ]))
                          ],
                        )))
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 16, left: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                          tag: "event2",
                          child: PictureButton(
                            height: 180,
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            pic: const AssetImage("assets/images/cocktail.jpg"),
                            children: <Widget>[
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: const Text(
                                    "Design Architecture",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: const Text(
                                    "Warren Street Station",
                                    style: TextStyle(
                                        color: Color(0xaaffffff), fontSize: 12),
                                  )),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  width: 70,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xDD333333)),
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Ends Today",
                                          style: TextStyle(
                                              color: Color(0xaaffffff),
                                              fontSize: 10),
                                        ),
                                      ]))
                            ],
                          )),
                      Hero(
                          tag: "event3",
                          child: PictureButton(
                            height: 180,
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            pic: const AssetImage("assets/images/carnival.jpg"),
                            children: <Widget>[
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: const Text(
                                    "MyBNK Vitality 10K 2019",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: const Text(
                                    "Sports / Green Park",
                                    style: TextStyle(
                                        color: Color(0xaaffffff), fontSize: 12),
                                  )),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  width: 70,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xDD333333)),
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Tue / 18:00",
                                          style: TextStyle(
                                              color: Color(0xaaffffff),
                                              fontSize: 10),
                                        ),
                                      ]))
                            ],
                          ))
                    ]))
          ],
        ));
  }
}
