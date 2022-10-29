import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lankabell_km/constants.dart';
import 'package:lankabell_km/screens/auth/login_screen.dart';
import 'package:lankabell_km/screens/detail_screen.dart';
import 'package:lankabell_km/screens/homepage.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  CollectionReference problemCollection =
      Firestore.instance.collection('problems');

  late Future<List<Document>> problem;

  // late List<Document> problems;

  Future<List<Document>> getProblems(bool isFilter, [String? filterText]) {
    if (!isFilter) {
      Future<List<Document>> result = problemCollection.get();
      problem = result;
      return result;
    } else {
      Future<List<Document>> result =
          problemCollection.where('category', isEqualTo: filterText).get();
      problem = result;
      return result;
    }
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    getProblems(false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Hii');
    return Scaffold(
        body: Stack(
      children: [
        Opacity(
          opacity: 0.2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage("assets/bg2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: 600,
            width: double.infinity,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 40,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.cover,
                        ))),
                // Container(
                //   width: MediaQuery.of(context).size.width * 1 / 2,
                //   child: TextField(
                //     controller: _searchController,
                //     onChanged: (value) {
                //       fetchById(value);
                //       // setState(() {
                //       //   visible == false;
                //       // });
                //     },
                //     decoration: InputDecoration(
                //       hintText: 'Search issue.',
                //       // prefixIconColor: Colors.red,
                //       prefixIcon: Icon(Icons.search),

                //       contentPadding: EdgeInsets.symmetric(
                //           vertical: 10.0, horizontal: 20.0),
                //       border: OutlineInputBorder(
                //         borderSide:
                //             BorderSide(color: primaryBlueColor, width: 4.0),
                //         borderRadius: BorderRadius.all(Radius.circular(15.0)),
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width * 1 / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(color: Colors.black)),
                              backgroundColor:
                                  MaterialStateProperty.all(backgroundGrey),
                            ),
                            onPressed: () {
                              setState(() {
                                getProblems(true, 'People');
                              });
                            },
                            child: Text(
                              'People',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(color: Colors.black)),
                                backgroundColor:
                                    MaterialStateProperty.all(backgroundGrey)),
                            onPressed: () {
                              setState(() {
                                getProblems(true, 'Technology');
                              });
                            },
                            child: Text(
                              'Technology',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(color: Colors.black)),
                                backgroundColor:
                                    MaterialStateProperty.all(backgroundGrey)),
                            onPressed: () {
                              setState(() {
                                getProblems(true, 'Structure');
                              });
                            },
                            child: Text(
                              'Structure',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(color: Colors.black)),
                                backgroundColor:
                                    MaterialStateProperty.all(backgroundGrey)),
                            onPressed: () {
                              setState(() {
                                getProblems(true, 'Culture');
                              });
                            },
                            child: Text(
                              'Culture',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    padding: EdgeInsets.all(20),
                    // height: 800,
                    decoration: BoxDecoration(
                        color: backgroundGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: FutureBuilder<List<Document>>(
                      future: problem,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!.isEmpty
                              ? Center(child: Text('No records found'))
                              : ListView(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  children: snapshot.data!.map((prob) {
                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              DetailScrenn(
                                            problemDetails: prob,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    prob['problem'],
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  Text(
                                                    prob['category'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: prob['vote'] == 'useful'
                                                    ? Icon(
                                                        Icons.thumb_up,
                                                        color: Colors.green,
                                                      )
                                                    : prob['vote'] ==
                                                            'notuseful'
                                                        ? Icon(
                                                            Icons.thumb_down,
                                                            color:
                                                                primaryRedColor,
                                                          )
                                                        : null)
                                          ],
                                        ),
                                      ),
                                    );
                                    // return ListTile(

                                    //   tileColor: Colors.white,
                                    //   title: Text(prob['problem']),
                                    //   subtitle: Text(prob['category']),
                                    // );
                                  }).toList(),
                                );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Want to post Solution?'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  LoginScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: Text('Go to admin page'))
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
