import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _lastTime;
  late int time;

  Future<void> handlepress() async{
    final prefs = await _prefs;

    setState(() {
      _lastTime = prefs.setInt("gaga", time).then((bool succes) => time);
      isMed = !isMed;
    });
  }

  @override
  void initState() {
    super.initState();
    _lastTime = _prefs.then((SharedPreferences pref){
      return pref.getInt("gaga") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    final minutes = DateTime.now().minute;
    final hours = DateTime.now().hour;
    final seconds = DateTime.now().second;
    time = (hours * 3600) + (minutes * 60)  + seconds;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Text(
            " ~ Medicine Reminder ~ ",
            style: TextStyle(
              color: Colors.amber[200],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: isMed ? Colors.green[200] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your Last Take : $time"),
                FutureBuilder<int>(
                  future: _lastTime,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                    return Text("Snapshot : ${snapshot.data}");
                  },
                ),
                Text("Live time (second)  : $time"),
                Text("Live Time : ${DateTime.now()}"),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  child: const Icon(
                    Icons.add_task,
                  ),
                  onPressed: (){
                    handlepress();
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


