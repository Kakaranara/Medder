import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isMed = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Medder",
            style: TextStyle(
              color: Colors.amber[200],
            ),
          ),
        ),
        elevation: 0.0,


      ),
      body: Container(
        color: isMed ? Colors.green[200] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(""),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  child: const Icon(
                    Icons.add_task,
                  ),
                  onPressed: (){
                    setState(() {
                      isMed = !isMed;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20.0),
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(
                  isMed ? "You Have Taken Medicine ! " : "You haven't take your med."
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


