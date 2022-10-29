import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lankabell_km/constants.dart';
import 'package:lankabell_km/screens/auth/login_screen.dart';
import 'package:lankabell_km/screens/dashboard_screen.dart';

class EditScreen extends StatefulWidget {
  Document problemDetails;
  EditScreen({required this.problemDetails, super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  //firestore collections
  CollectionReference problemCollection =
      Firestore.instance.collection('problems');

  TextEditingController _problemController = TextEditingController();
  TextEditingController _solutionController = TextEditingController();

  //form data
  String dropdownValue = list[0];
  bool isAdding = false;

  @override
  void initState() {
    _problemController.text = widget.problemDetails['problem'];
    _solutionController.text = widget.problemDetails['solution'];
    dropdownValue = widget.problemDetails['category'];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 70),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          Dashboard(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Text('Dashboard')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
        child: Container(
          height: 600,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Spacer(),
              Text(
                'Edit Record',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 1 / 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Problem'),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _problemController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter problem',
                          filled: true,
                          fillColor: Color.fromARGB(255, 238, 238, 238),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text('Category'),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 238, 238, 238),
                        ),
                        padding: EdgeInsets.only(left: 15),
                        width: double.infinity,
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(20),

                          value: dropdownValue,
                          // icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          // style: const TextStyle(
                          //   color: Colors.deepPurple,
                          // ),
                          underline: Container(
                            height: 0,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text('Solution'),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _solutionController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter problem',
                          filled: true,
                          fillColor: Color.fromARGB(255, 238, 238, 238),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryBlueColor),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 40),
                                ),
                              ),
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //       content: Text('Processing Data')),
                                  // );
                                  setState(() {
                                    isAdding = true;
                                  });
                                  var data = await problemCollection
                                      .document(widget.problemDetails.id)
                                      .update({
                                    'problem': _problemController.text,
                                    'category': dropdownValue,
                                    'solution': _solutionController.text,
                                    'vote': 'undefined'
                                  });

                                  setState(() {
                                    isAdding = false;
                                  });

                                  _problemController.clear();
                                  _solutionController.clear();
                                  showAlertDialog(
                                      context, 'Record Updated Successfully');
                                }
                              },
                              child: isAdding ? Text('Adding') : Text('Update'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String text) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => Dashboard()),
        ),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(child: Text(text)),
    content: Icon(
      Icons.check_circle_outline_rounded,
      size: 150,
      color: Colors.green,
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

const List<String> list = <String>[
  'People',
  'Technology',
  'Structure',
  'Culture'
];
