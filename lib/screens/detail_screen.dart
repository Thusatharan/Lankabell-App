import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lankabell_km/constants.dart';

enum Vote { useful, notuseful, undefined }

class DetailScrenn extends StatefulWidget {
  Document problemDetails;
  DetailScrenn({required this.problemDetails, super.key});

  @override
  State<DetailScrenn> createState() => _DetailScrennState();
}

class _DetailScrennState extends State<DetailScrenn> {
  CollectionReference problemCollection =
      Firestore.instance.collection('problems');

  var vote = 'undefined';

  Future<void> fetchById() async {
    var doc = await Firestore.instance
        .collection('problems')
        .document(widget.problemDetails.id)
        .get();

    setState(() {
      vote = doc.map['vote'];
    });
  }

  @override
  void initState() {
    fetchById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solutions',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 2 / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Problem'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '${widget.problemDetails['category']}',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.problemDetails['problem'],
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.only(top: 40),
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    padding: EdgeInsets.all(20),
                    // height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: backgroundGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solution'.toUpperCase(),
                          style: TextStyle(
                              // color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.problemDetails['solution'],
                          style: TextStyle(
                              // color: Colors.green,
                              ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                                TextStyle(color: Colors.black)),
                            backgroundColor: MaterialStateProperty.all(
                                (vote == 'useful')
                                    ? Colors.green
                                    : Color.fromARGB(255, 241, 241, 241)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20))),
                        onPressed: () {
                          problemCollection
                              .document(widget.problemDetails.id)
                              .update({'vote': 'useful'}).then(
                                  (_) => fetchById());
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: (vote == 'useful')
                                  ? Colors.white
                                  : Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Useful',
                              style: TextStyle(
                                  color: (vote == 'useful')
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                                TextStyle(color: Colors.black)),
                            backgroundColor: MaterialStateProperty.all(
                                (vote == 'notuseful')
                                    ? Colors.green
                                    : Color.fromARGB(255, 241, 241, 241)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20))),
                        onPressed: () {
                          problemCollection
                              .document(widget.problemDetails.id)
                              .update({'vote': 'notuseful'}).then(
                                  (_) => fetchById());
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_down,
                              color: (vote == 'notuseful')
                                  ? Colors.white
                                  : Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Not Useful',
                              style: TextStyle(
                                  color: (vote == 'notuseful')
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
