import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lankabell_km/constants.dart';
import 'package:lankabell_km/screens/auth/login_screen.dart';
import 'package:lankabell_km/screens/edit_screen.dart';
import 'package:lankabell_km/screens/homepage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CollectionReference problemCollection =
      Firestore.instance.collection('problems');

  Future<List<Document>> getProblems() async {
    List<Document> problems = await problemCollection.get();
    print(problems);
    print('problems');
    return problems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          HomePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Text('Create Record')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          LoginScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                'All Records',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1 / 2,
                child: FutureBuilder<List<Document>>(
                  future: getProblems(),
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
                                return Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
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
                                              style: TextStyle(fontSize: 15),
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
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: (() {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          EditScreen(
                                                        problemDetails: prob,
                                                      ),
                                                      transitionDuration:
                                                          Duration.zero,
                                                      reverseTransitionDuration:
                                                          Duration.zero,
                                                    ),
                                                  );
                                                }),
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                onPressed: (() {
                                                  // set up the button
                                                  Widget cancelButton =
                                                      TextButton(
                                                    child: Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                  Widget okButton = TextButton(
                                                    child: Text("Yes"),
                                                    onPressed: () {
                                                      problemCollection
                                                          .document(prob.id)
                                                          .delete()
                                                          .then((value) =>
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context,
                                                                          animation1,
                                                                          animation2) =>
                                                                      Dashboard(),
                                                                  transitionDuration:
                                                                      Duration
                                                                          .zero,
                                                                  reverseTransitionDuration:
                                                                      Duration
                                                                          .zero,
                                                                ),
                                                              ));
                                                    },
                                                  );

                                                  // set up the AlertDialog
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title:
                                                        Text('Are you sure?'),
                                                    actions: [
                                                      cancelButton,
                                                      okButton
                                                    ],
                                                  );

                                                  // show the dialog
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alert;
                                                    },
                                                  );
                                                }),
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
